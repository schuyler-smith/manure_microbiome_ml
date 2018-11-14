/*
 * 
 *
 * 
 *      Author: Schuyler Smith
 */

#include "Rcpp.h"
// [[Rcpp::depends(RcppParallel)]]
#include <RcppParallel.h>
#include <iostream>
#include <string>
#include <regex>

using namespace std;

struct MatchSeqs : public RcppParallel::Worker
{
	Rcpp::StringVector input1;
	Rcpp::StringVector input2;

	MatchSeqs(Rcpp::StringVector input1, Rcpp::StringVector input2) 
      : input1(input1), input2(input2) {}


    void operator()(std::size_t begin, std::size_t end) {
      std::transform(input.begin() + begin, 
                     input.begin() + end, 
                     output.begin() + begin, 
                     ::sqrt);
   }

    for(int i=0; i<input2.size(); ++i){
    	string seq2 (input2[i]);
    	for(int j=0; j<input1.size(); ++j){
    		string seq1 (input1[j]);
    		if (seq2.find(seq1) != std::string::npos) {
    			input2[i] = seq1;
			}
    	}
    }
};


// [[Rcpp::export]]

Rcpp::StringVector match_seqs(Rcpp::StringVector in1, Rcpp::StringVector in2){


    return(input2);
}



