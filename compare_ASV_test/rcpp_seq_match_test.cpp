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

Rcpp::DataFrame test_match(Rcpp::NumericMatrix s_input, Rcpp::NumericMatrix l_input){

    Rcpp::List s_names = s_input.attr("dimnames"); 
    Rcpp::List l_names = l_input.attr("dimnames"); 
    Rcpp::StringVector shorter_seqs = s_names[0];
    Rcpp::StringVector longer_seqs = l_names[0];
    int s_size = s_input.nrow();
    int l_size = l_input.nrow();

    for(int i=0; i<l_size; ++i){
        string l_seq (longer_seqs[i]);
        for(int j=0; j<s_size; ++j){
            string s_seq (shorter_seqs[j]);
            if (l_seq.find(s_seq) != std::string::npos) {
                longer_seqs[i] = s_seq;
                break;
            }
        }
    }

    
    return longer_seqs;
}



