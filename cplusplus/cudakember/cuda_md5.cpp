#include <string.h>
#include <stdio.h>
#include <sys/time.h>
#include <iostream>
#include <vector>
#include <valarray>
#include <sstream> 
#include <cuda_runtime_api.h>
#include "cutil.h"
#include "util.h"

#define MD5_CPU				md5_cpu_v2
int niters = 10;

typedef unsigned int uint;

// Some declarations that should wind up in their own .h file at some point
void print_md5(uint *hash, bool crlf = true);
void md5_prep(char *c0);
double execute_kernel(int blocks_x, int blocks_y, int threads_per_block, int shared_mem_required, int realthreads, uint *gpuWords, uint *gpuHashes, int mode = 0);
double kember_execute(int blocks_x, int blocks_y, int threads_per_block,
		      uint a, uint b, uint c, uint d, uint bsz, uint* result);
void init_constants(uint *target = NULL);
void md5_cpu(uint w[16], uint &a, uint &b, uint &c, uint &d);
void md5_cpu_v2(const uint *in, uint &a, uint &b, uint &c, uint &d);
int deviceQuery();


//
///////////////////////////////////////////////////////////

//
// Shared aux. functions (used both by GPU and CPU setup code)
//
union md5hash
{
  uint ui[4];
  uint64_t ui64[2];
  char ch[16];
};


md5hash single_md5(std::string &ptext)
{
	md5hash h;

	char w[64] = {0};
	strncpy(w, ptext.c_str(), 56);
	md5_prep(w);
	MD5_CPU((uint*)&w[0], h.ui[0], h.ui[1], h.ui[2], h.ui[3]);

	return h;
}


int kember_search(uint64_t seed, uint64_t resume = 0) {
  std::cout << "Starting Kember Identity Search with Seed " << seed << "\n";

  size_t blocksize = 1024*1024*5; // total hashes to compute in 1 iteration
  int tpb = 255;

  std::cout << "Block size is " << blocksize << "\n";
  std::cout << seed << " " << resume << "\n";

  std::vector<md5hash> hashset;
  md5hash h = {0};  h.ui64[0] = seed;  h.ui64[1] = resume;
  md5hash gpumd5 = {0};

  std::cout << "Initial hash "; print_md5(h.ui, true);

  // Upload the dictionary onto the GPU device
  uint *result = NULL;
  const uint tmp[4] = {0};
  CUDA_SAFE_CALL( cudaMalloc((void **)&result, sizeof(md5hash)) );
  CUDA_SAFE_CALL( cudaMemcpy(result, tmp, sizeof(md5hash), cudaMemcpyHostToDevice) );

  do {
    struct timeval start_time;
    gettimeofday(&start_time, NULL);

    std::cout << "Searching from " << h.ui64[0] << " " << h.ui64[1] << " ";

    double gpuTime = kember_execute((blocksize/tpb)+1, 1, tpb,
				    h.ui[0], h.ui[1], h.ui[2], h.ui[3],
				    blocksize, result);
    CUDA_SAFE_CALL( cudaMemcpy(gpumd5.ch, result, sizeof(md5hash), cudaMemcpyDeviceToHost) );

    if(result && gpumd5.ui64[0] != 0 && gpumd5.ui64[1] != 0) {
      std::cout << "\nKEMBER IDENTITY FOUND\n";

      md5hash cpumd5 = {0};

      MD5_CPU(gpumd5.ui, cpumd5.ui[0], cpumd5.ui[1], cpumd5.ui[2], cpumd5.ui[3]);

      if(memcmp(cpumd5.ui, gpumd5.ui, 16) == 0) {
	std::cout << "VERIFIED IDENTITY ON CPU!\n";
      } else {
	std::cout << "FAILED TO VERIFY IDENTITY WITH CPU!\n";
      }

      std::cout << "GPU: "; print_md5(gpumd5.ui, true);
      std::cout << "CPU: "; print_md5(cpumd5.ui, true);
      return 0;
    }

    std::cout << "No matches found. ";

    if(h.ui64[1] + blocksize < h.ui64[1]) h.ui64[0] += 1;
    h.ui64[1] += blocksize;

    struct timeval end_time;
    gettimeofday(&end_time, NULL);
    
    float duration = (end_time.tv_sec + (end_time.tv_usec / 1000000.0)) - (start_time.tv_sec + (start_time.tv_usec / 1000000.0));

    int hreal = blocksize / duration;
    int hgpu = blocksize / (gpuTime / 1000.0);

    std::cout << "\n";
    std::cout << hreal << " hashes/realsec " << "(gpusec " << (hgpu-hreal) << ")\n\n";
  } while(1);
  CUDA_SAFE_CALL( cudaFree(result) );
}

int main(int argc, char **argv)
{
	option_reader o;

	bool devQuery = false, benchmark = false, kember = false;
	std::string target_word;
	std::string kember_seed;
	std::string kember_resume;
	bool kember_randseed = false;

	o.add("deviceQuery", devQuery, option_reader::flag);
	o.add("kember", kember_seed, option_reader::optparam);
	o.add("kember-resume", kember_resume, option_reader::optparam);
	o.add("kember", kember_randseed, option_reader::flag);

	if(!o.process(argc, argv))
	{
		std::cerr << "Usage: " << o.cmdline_usage(argv[0]) << "\n";
		return -1;
	}

	if(devQuery) { return deviceQuery(); }

	CUT_DEVICE_INIT(argc, argv);

	if(!kember_seed.empty() || kember_randseed) {
	  uint64_t seed = 0;
	  uint64_t resume = 0;

	  if(kember_randseed) {
	    srand(time(NULL));
	    seed = ((uint64_t)rand() | (rand() >> 16)) << 32;
	    seed |= ((uint64_t)rand() | (rand() >> 16));
	  } else {
	    std::stringstream kseed; kseed << kember_seed;
	    kseed >> seed;

	    kseed.clear();
	    kseed << kember_resume;
	    kseed >> resume;
	  }
	  return kember_search(seed, resume);
	}

}
