/*
 * 
 *
 * 
 *      Author: Schuyler Smith
 */
#include <iostream>
#include <string>
#include <regex>
#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]
using namespace std;

// [[Rcpp::export]]

Rcpp::DataFrame test_match(Rcpp::NumericMatrix s_input, Rcpp::NumericMatrix l_input){

    Rcpp::StringVector shorter_seqs = rownames(s_input);
    Rcpp::StringVector longer_seqs = rownames(l_input);
    int s_size = s_input.nrow();
    int l_size = l_input.nrow();

    vector<int> dup_rows;
    int ind; //create index counter for original of duplicate seq names
    for(int i=0; i<s_size; ++i){ //loop through each sequence of set with shorter read lengths
        string s_seq (shorter_seqs[i]);
        ind = -1; //assign ind to not be within the dataframe
        for(int j=0; j<l_size; ++j){ //loop through other dataset
            string l_seq (longer_seqs[j]);
            if (l_seq.find(s_seq) != std::string::npos){ //if seq 1 is contained in seq 2
                longer_seqs[j] = s_seq;
                if (ind == -1){
                    ind = j;
                } else {
                    l_input(ind,Rcpp::_) = l_input(ind,Rcpp::_) + l_input(j,Rcpp::_); //add values to original
                    dup_rows.push_back(j); //keep track of inidices of duplicated seqs
                }
            }
        }
    }
    std::sort(dup_rows.begin(), dup_rows.end()); //sort the indices to iterate through
    arma::mat y = Rcpp::as<arma::mat>(l_input);
    int dup_size = dup_rows.size();
    for(int r=0; r<dup_size; ++r){
        y.shed_row(dup_rows[r]-r);
        // longer_seqs.erase(dup_rows[r]-r);
    }
    
    return longer_seqs;
}



