# Makefile
#
# author      : sam adams, modified by Mario Juric <mjuric@ias.edu>
# version     : 0.2
# date        : 20080212
# discription : generic Makefile for making cuda programs
#
BIN               := cuda_md5

# flags
CUDA_INSTALL_PATH := /usr/local/cuda
INCLUDES          += -I. -I$(CUDA_INSTALL_PATH)/include -I/Developer/CUDA/common/inc
LIBS              := -L$(CUDA_INSTALL_PATH)/lib -L/Developer/CUDA/lib
CXXFLAGS          := -O3
LDFLAGS           := -lm -lcudart -lcutil -Wl,-rpath,/Developer/CUDA/lib -Wl,-rpath,/usr/local/cuda/lib
# compilers
#NVCC              := nvcc --device-emulation -arch sm_11
NVCC              := nvcc -arch sm_11 -O3

# files
CPP_SOURCES       := cuda_md5.cpp cuda_md5_cpu.cpp deviceQuery.cpp util.cpp
CU_SOURCES        := cuda_md5_gpu.cu
HEADERS           := $(wildcard *.h)
CPP_OBJS          := $(patsubst %.cpp, %.o, $(CPP_SOURCES))
CU_OBJS           := $(patsubst %.cu, %.cu_o, $(CU_SOURCES))

%.cu_o : %.cu
	$(NVCC) -c $(INCLUDES) -o $@ $<

%.o: %.cpp
	$(CXX) -c $(CXXFLAGS) $(INCLUDES) -o $@ $<

$(BIN): $(CPP_OBJS) $(CU_OBJS)
	$(CXX) -o $(BIN) $(CU_OBJS) $(CPP_OBJS) $(LDFLAGS) $(INCLUDES) $(LIBS)

benchmark: cuda_md5
	@mkdir -p bench/figs bench/data
	@./cuda_md5 --deviceQuery | tee bench/data/`hostname`.device.dat
	@echo
	@echo "Running benchmarks -- this may take awhile."
	@echo
	@echo -n "Benchmarking MD5 compute: "
	@(cat wordlist.txt | ./cuda_md5 --benchmark | sed -r 's/ *[^ ]+=/\t/g' > bench/data/bench.`hostname`.calc.dat) 2>&1 | grep GPU
	@echo -n "Benchmarking MD5 search: "
	@(cat wordlist.txt | ./cuda_md5 --benchmark --search=AliceBob | sed -r 's/ *[^ ]+=/\t/g' > bench/data/bench.`hostname`.search.dat) 2>&1 | grep GPU
	@tar czf cudamd5-bench-results.tar.gz bench/data/bench.`hostname`.search.dat bench/data/bench.`hostname`.calc.dat bench/data/`hostname`.device.dat
	@echo
	@echo
	@echo "I've tarballed the results of this benchmark to cudamd5-bench-results.tar.gz."
	@echo "E-mail this file to mjuric@ias.edu who keeps a compilation of benchmark results"
	@echo "for various CUDA GPUs at http://majuric.org/software/cudamd5/."
	@echo
	@echo "The tarball contains no personally identifiable information other than"
	@echo "the hostname and the specifications of your GPU. You are encouraged to"
	@echo "untar it and check for yourself."
	@echo
	@echo "Thanks!  Mario Juric <mjuric@ias.edu>"
	@echo

util.o: util.cpp util.h
cuda_md5.o: cuda_md5.cpp util.h

clean:
	rm -f $(BIN) *.o *.cu_o
