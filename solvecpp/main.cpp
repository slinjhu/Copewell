#include <iostream>
#include <vector>
#include <chrono>
#include <cmath>
#include <boost/numeric/odeint.hpp>
using namespace std;
using namespace boost::numeric::odeint;

typedef vector<double> state_type;

const double Event_damage_rate_constant = 4;
const double ER_flow_rate_constant  = 1;
const double PR_flow_rate_constant = 1;
const double SC_flow_rate_constant   = 1;
const double CF_depletion_rate_constant = 5;


void df(const state_type &x , state_type &dxdt , double t){
  const double CF = x[0];
  const double PR = x[1];
  const double PM = x[2];
  const double PVID = x[3];
  const double SC = x[4];
  const double ER = 0.5;
  const double CF0 = x[5];
  const double Event0 = x[6];
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


  dxdt[0] = - CF_depletion_rate + CF_replenish_rate;
  dxdt[1] = - PR_flow_rate;
  dxdt[2] = 0; // constant PM
  dxdt[3] = 0; // constant PVID
  dxdt[4] = - SC_flow_rate;
  dxdt[5] = 0; // constant CF0
  dxdt[6] = 0; // constant Event0
}

void writef( const state_type &x , const double t){
  cout << t << ":\t" << x[0] << endl;
}

int main(int argc, char **argv){
  int N = 3500;
  vector<int> result (N, 0);
#pragma omp parallel for
  for(int i = 0; i < N; i++){
    double CF0 = 1;
    state_type x = {CF0, 0.5, 0.5, 0.5, 0.5, CF0, 0.5};
    integrate(df, x , 0.0, 12.0 , 0.01);
    //result[i] = i;
  }

}
