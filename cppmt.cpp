#include <iostream>
#include <thread>
static const int num_of_threads = 6;
//This is the function that will run in parallel
// It will be passed to the thread

template <typename RAIter>
void loop_in_parallel(RAIter first, RAIter last) {
   const size_t n = std::distance(first, last);

   #pragma omp parallel for
   for (size_t i = 0; i < n; i++) {
       auto& elem = *(first + i);
       // do whatever you want with elem
    }
}

int main() {
	
	return 0;
}