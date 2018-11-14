/*
 * 
 *
 * 
 *      Author: Schuyler Smith
 */
#include "Rcpp.h"
#include <iostream>
#include <string>
#include <regex>

using namespace std;

// [[Rcpp::export]]

Rcpp::StringVector match_seqs(Rcpp::StringVector input1, Rcpp::StringVector input2){

    int size1 = input1.size();
    int size2 = input2.size();

    for(int i=0; i<size1; ++i){
    	string seq1 (input1[i]);
    	for(int j=0; j<size2; ++j){
    		string seq2 (input2[j]);
    		if (seq2.find(seq1) != std::string::npos) {
    			input2[j] = seq1;
			}
    	}
    }

    return(input2);
}



