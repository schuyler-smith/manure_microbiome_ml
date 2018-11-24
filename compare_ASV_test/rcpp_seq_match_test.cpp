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
#ifdef _OPENMP
  #include <omp.h>
#endif
// [[Rcpp::plugins(openmp)]]
using namespace std;

// [[Rcpp::export]]

Rcpp::DataFrame test_match(Rcpp::NumericMatrix short_input, Rcpp::NumericMatrix long_input){

    Rcpp::StringVector shorter_seqs = rownames(short_input);
    Rcpp::StringVector longer_seqs = rownames(clone(long_input));
    arma::mat l_input = Rcpp::as<arma::mat>(clone(long_input));
    int s_size = short_input.nrow();
    int l_size = long_input.nrow();


    vector<double> dup_rows;
    vector<double> og_seqs;
    int ind; //create index counter for original of duplicate seq names
    // #pragma omp parallel for shared(long_input)
    #pragma omp parallel for shared(l_input)
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
                    og_seqs.push_back(ind);
                    dup_rows.push_back(j); //keep track of inidices of duplicated seqs
                }
            }
        }
    }

    arma::mat M(dup_rows);
    arma::uvec indices = sort_index(M, "descend");
    int dup_size = og_seqs.size();
    for(int r=0; r<dup_size; ++r){ //remove data rows and duplicate taxa names
        int index (indices[r]);
        l_input.row(og_seqs[index]) = l_input.row(og_seqs[index]) + l_input.row(dup_rows[index]); //add values to original
        l_input.shed_row(dup_rows[index]);
        longer_seqs.erase(dup_rows[index]);
    }
    Rcpp::NumericMatrix x = Rcpp::wrap(l_input); //convert back to rcpp matrix
    rownames(x) = longer_seqs;
    colnames(x) = colnames(long_input);
    
    return x;
}



