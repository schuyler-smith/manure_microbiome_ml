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

Rcpp::StringVector match_seqs(Rcpp::StringVector s_input, Rcpp::StringVector l_input){

    int s_size = s_input.size();
    int l_size = l_input.size();

   //  for(int i=0; i<s_size; ++i){
   //  	string s_seq (s_input[i]);
   //  	for(int j=0; j<l_size; ++j){
   //  		string l_seq (l_input[j]);
   //  		if (l_seq.find(s_seq) != std::string::npos) {
   //  			l_input[j] = s_seq;
			// }
   //  	}
   //  }
    for(int i=0; i<l_size; ++i){
        string l_seq (l_input[i]);
        for(int j=0; j<s_size; ++j){
            string s_seq (s_input[j]);
            if (l_seq.find(s_seq) != std::string::npos) {
                l_input[i] = s_seq;
                break;
            }
        }
    }


    return(l_input);
}



