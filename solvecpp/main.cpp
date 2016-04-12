#include <iostream>
#include <fstream>
#include <sstream>
#include <map>
#include <vector>
#include <chrono>
#include <boost/numeric/odeint.hpp>
using namespace std;

typedef vector<double> VD;
struct HistoryEntry{double t, CF;};
typedef vector<HistoryEntry> History;
struct Result{double resistance, recovery, resilience;};

struct Observer{
  History& log;
  Observer(History& vlog):log(vlog){}
  void operator()(const VD &x, double t){
    log.push_back({t, x[0]});
  }
};

// ODE parameters
const double Event_damage_rate_constant = 4;
const double ER_flow_rate_constant  = 1;
const double PR_flow_rate_constant = 1;
const double SC_flow_rate_constant   = 1;
const double CF_depletion_rate_constant = 5;


void df (const VD& x , VD& dxdt , double t){
  const double CF = x[0];
  const double PR = x[1];
  const double PM = x[2];
  const double PVID = x[3];
  const double SC = x[4];
  //const double Event0 = x[5];
  const double Event0 = 1;
  const double ER = 0.5;
  const double CF0 = x[6];
  
  // CF replenishment
  const double CF_drop = max( CF0 - CF, 0.0 );
  const double SC_flow_rate = SC_flow_rate_constant * CF * SC * CF_drop;
  const double PR_flow_rate = PR_flow_rate_constant * PR * CF_drop;
  const double ER_flow_rate = ER_flow_rate_constant * ER * CF_drop;
  const double CF_replenish_rate = SC_flow_rate + PR_flow_rate + ER_flow_rate;
  // CF depletion
  const double k = Event_damage_rate_constant;
  const double Event_t = Event0 * k * exp(-k * t);
  const double Event_damage_rate =  Event_t * (2 - PM - PVID)/2;
  const double CF_depletion_rate = CF_depletion_rate_constant * CF * Event_damage_rate;
  // Derivatives
  dxdt[0] = - CF_depletion_rate + CF_replenish_rate;
  dxdt[1] = - PR_flow_rate;
  dxdt[2] = 0; // constant PM
  dxdt[3] = 0; // constant PVID
  dxdt[4] = - SC_flow_rate;
  dxdt[5] = 0; // constant Event0
  dxdt[6] = 0; // constant CF0
}

double area(const History & hist){
  // Calculate area under the curve
  double area = 0;
  for(size_t i = 1; i < hist.size(); i++){
    double dt = hist[i].t - hist[i-1].t;
    area += dt * 0.5 * (hist[i].CF + hist[i-1].CF);
  }
  return area;
}

Result analyze(const History & hist){
  const double CF0 = hist[0].CF;
  // Find nadir and half recovery
  auto nadir = &hist[0];
  double thalf = 100;
  for(size_t i = 1; i < hist.size(); i++){
    if(nadir->CF > hist[i].CF){
      nadir = &(hist[i]);
    }else{
      double CFhalf = 0.5*(CF0 + nadir->CF);
      if(hist[i].CF > CFhalf){
        double ratio = (hist[i].t - hist[i-1].t) / (hist[i].CF - hist[i-1].CF);
        thalf = hist[i-1].t + ratio * (CFhalf - hist[i-1].CF);
        break;
      }
    }
  }
  double resistance = nadir->CF / CF0;
  double recovery = 1.0 / thalf;
  double resilience = area(hist) / 12.0 / CF0;
  return {resistance, recovery, resilience};
}

vector<pair<int,VD>> load(string filename){
  vector<pair<int,VD>> x0s;
  ifstream fid (filename);
  if(fid.is_open()){
    string line;
    getline(fid, line); // skip the first line
    while(getline(fid, line)){
      stringstream ss(line);
      // Get fips code
      int fips;
      ss >> fips;
      ss.ignore();
      // Get all values 
      double num;
      VD x0;
      while(ss >> num){
        x0.push_back(num);
        if(ss.peek() == ',') ss.ignore();
      }
      x0.push_back(x0[0]); // CF0
      x0s.push_back({fips, x0});
    }
  }
  return x0s;
}

int main(int argc, char **argv){
  auto x0s = load("domain.csv");
  vector<pair<int,Result>> results (x0s.size());

  //#pragma omp parallel for
  for(size_t i = 0; i < x0s.size(); i++){
    const int fips = x0s[i].first;
    VD x = x0s[i].second;
    History hist;
    boost::numeric::odeint::integrate(df, x , 0.0, 12.0 , 0.01, Observer(hist));
    results[i] = {fips, analyze(hist)};
  }

  // Write to file
  ofstream outfile;
  outfile.open("out.csv");
  outfile << "fips,resistance,recovery,resilience\n";
  for(auto pr : results){
    Result rslt = pr.second;
    outfile << pr.first << ","
            << rslt.resistance << ","
            << rslt.recovery << ","
            << rslt.resilience << endl;
  }

}
