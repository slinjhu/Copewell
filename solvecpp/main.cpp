#include <iostream>
#include <vector>
#include <chrono>
#include <cmath>
#include <boost/numeric/odeint.hpp>
using namespace std;
using namespace boost::numeric::odeint;

// ================ Class to track time
typedef chrono::high_resolution_clock HRTime;
typedef chrono::time_point<HRTime> TimePoint;
typedef std::chrono::duration<float> fsec;
class Timer{
private:
  TimePoint t0;
public:
  Timer(){
    t0 = HRTime::now();
    trackMUS("Timer created");
  }
  float trackMUS(string message){
    // Print the elapsed time. 
    auto t1 = HRTime::now();
    fsec fs = t1 - t0;
    float duration = fs.count() * 1000000 ;
    cout << message << ": " << duration << " micro sec\n";
    return duration;
  }

  void track(string message){
    // Print the elapsed time. 
    auto t1 = HRTime::now();
    fsec fs = t1 - t0;
    cout << message << ": " << fs.count() << " s\n";
  }

  void reset(){
    t0 = HRTime::now();
  }
};


const double sigma = 10.0;
const double R = 28.0;
const double b = 8.0 / 3.0;

typedef vector<double> state_type;


void lorenz( const state_type &x , state_type &dxdt , double t )
{
  dxdt[0] = sigma * ( x[1] - x[0] );
  dxdt[1] = R * x[0] - x[1] - x[0] * x[2];
  dxdt[2] = -b * x[2] + x[0] * x[1];
}

void write_lorenz( const state_type &x , const double t )
{
  cout << t << '\t' << x[0] << '\t' << x[1] << '\t' << x[2] << endl;
}

int main(int argc, char **argv){
  Timer timer;
  timer.reset();

#pragma omp parallel for
  for(int i = 0; i < 30; i++){
    state_type x = { 0 , 1.0 , 1.0 }; // initial conditions
    integrate( lorenz , x , 0.0 , 25.0 , 0.1  );
  }

  timer.track("Solve");
}
