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
struct ResilienceResult{double resistance, recovery, resilience;};

struct ODEObserver{
  History& log;
  ODEObserver(History& vlog):log(vlog){}
  void operator()(const VD &x, double t){log.push_back({t, x[0]});}
};

const map<string,int> csvHeader = {{"CF", 0}, {"PR", 1}, {"PM", 2}, {"PVID", 3}, {"SC", 4}, {"Event", 5}, {"CF0", 6}};

void df (const VD& x , VD& dxdt , double t);
double area(const History & hist);
ResilienceResult calculate_resilience(const History & hist);
void load_data(string filename, map<int,VD>& x0s);
double get_data(const VD & x0, string domain);
void set_data(VD & x0, string domain, double value);
void write_result(string filename, const map<int,ResilienceResult> & results);

int main(int argc, char **argv){
  if(argc != 3){
    cerr << "Please provide two arguments: domain.csv result.csv" << endl;
  }else{
    // Retrieve command line arguments
    const string domainDataFile = argv[1];
    const string resultDataFile = argv[2];

    // Load domain data from file
    map<int,VD> x0s; // fips -> x0
    load_data(domainDataFile, x0s);

    // Solve ODE
    map<int,ResilienceResult> results; // fips -> results
    for(auto it : x0s){
      const int fips = it.first;
      VD x = it.second;
      History hist;
      boost::numeric::odeint::integrate(df, x , 0.0, 12.0 , 0.01, ODEObserver(hist));
      results[fips] = calculate_resilience(hist);
    }
    write_result(resultDataFile, results);
  }
}

// ODE parameters
const double Event_damage_rate_constant = 4;
const double ER_flow_rate_constant  = 1;
const double PR_flow_rate_constant = 1;
const double SC_flow_rate_constant   = 1;
const double CF_depletion_rate_constant = 5;

// Solve ODE
void df (const VD& x , VD& dxdt , double t){
  const double CF = get_data(x, "CF");
  const double PR = get_data(x, "PR");
  const double PM = get_data(x, "PM");
  const double PVID = get_data(x, "PVID");
  const double SC = get_data(x, "SC");
  //const double Event0 = get_data(x, "Event");
  const double Event0 = 1;
  const double ER = get_data(x, "ER");
  const double CF0 = get_data(x, "CF0");

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
  set_data(dxdt, "CF", - CF_depletion_rate + CF_replenish_rate);
  set_data(dxdt, "PR", - PR_flow_rate);
  set_data(dxdt, "PM", 0);
  set_data(dxdt, "PVID", 0);
  set_data(dxdt, "SC", - SC_flow_rate);
  set_data(dxdt, "Event", 0);
  set_data(dxdt, "CF0", 0);
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

ResilienceResult calculate_resilience(const History & hist){
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

void load_data(string filename, map<int,VD>& x0s){
  ifstream fid (filename);
  if(!fid.is_open()){
    cerr << "Failed to open file: " << filename << endl;
  }else{
    string line, token;
    getline(fid, line); // skip fips
    // Read all data lines
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
      double CF = get_data(x0, "CF");
      x0.push_back(CF); // push CF0
      x0s.insert({fips, x0});
    }
  }
}

double get_data(const VD & x0, string domain){
  auto it = csvHeader.find(domain);
  if(it != csvHeader.end()){
    const int idx = it->second;
    return x0[idx];
  }else{
    return 0.5;
  }
}

void set_data(VD & x0, string domain, double value){
  auto it = csvHeader.find(domain);
  if(it != csvHeader.end()){
    x0[it->second] = value;
  }
}

void write_result(string filename, const map<int,ResilienceResult> & results){
  ofstream outfile;
  outfile.open(filename);
  outfile << "fips,resistance,recovery,resilience\n";
  for(auto pr : results){
    ResilienceResult rslt = pr.second;
    outfile << pr.first << ","
            << rslt.resistance << ","
            << rslt.recovery << ","
            << rslt.resilience << endl;
  }
}
