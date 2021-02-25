CXX = clang
CXXFLAGS = -rdynamic $(shell llvm-config --cxxflags) -g -O0 -std=c++14 -fno-discard-value-names

all: p34.so

%.so: %.o
	$(CXX) $(CXXFLAGS) -dylib -shared -fPIC  $^ -o $@

clean:
	rm -f *.o *~ *.so
