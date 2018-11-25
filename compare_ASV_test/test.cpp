// [[Rcpp::depends(RcppParallel)]]
#include <RcppParallel.h>
using namespace RcppParallel;

struct SquareRoot : public Worker
{
   // source matrix
   const RMatrix<double> input;
   
   // destination matrix
   RMatrix<double> output;
   
   // initialize with source and destination
   SquareRoot(const NumericMatrix input, NumericMatrix output) 
      : input(input), output(output) {}
   
   // take the square root of the range of elements requested
   void operator()(std::size_t begin, std::size_t end) {
      std::transform(input.begin() + begin, 
                     input.begin() + end, 
                     output.begin() + begin, 
                     ::sqrt);
   }
};

// [[Rcpp::export]]
NumericMatrix parallelMatrixSqrt(NumericMatrix x) {
  
  // allocate the output matrix
  NumericMatrix output(x.nrow(), x.ncol());
  
  // SquareRoot functor (pass input and output matrixes)
  SquareRoot squareRoot(x, output);
  
  // call parallelFor to do the work
  parallelFor(0, x.length(), squareRoot);
  
  // return the output matrix
  return output;
}



#include <Rcpp.h>
#include <RcppParallel.h>
#include <tbb/concurrent_vector.h>
using namespace Rcpp;

// [[Rcpp::depends(RcppParallel)]]
// [[Rcpp::plugins(cpp11)]]
struct Example : public RcppParallel::Worker {
  RcppParallel::RVector<double> xvals;
  tbb::concurrent_vector< std::pair<double, double> > &output;
  Example(const NumericVector & xvals, tbb::concurrent_vector< std::pair<double, double> > &output) : 
    xvals(xvals), output(output) {}
  void operator()(std::size_t begin, size_t end) {
    for(std::size_t i=begin; i < end; i++) {
      double y = xvals[i] * (xvals[i] - 1);
      if(y < 0) {
        output.push_back( std::pair<double, double>(xvals[i], y) );
      }
    }
  }
};
// [[Rcpp::export]]
List find_values(NumericVector xvals) {
  tbb::concurrent_vector< std::pair<double, double> > output;
  Example ex(xvals,output);
  parallelFor(0, xvals.size(), ex);
  NumericVector xout(output.size());
  NumericVector yout(output.size());
  for(int i=0; i<output.size(); i++) {
    xout[i] = output[i].first;
    yout[i] = output[i].second;
  }
  List L = List::create(xout, yout);
  return(L);
}

