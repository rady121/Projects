CXX=g++
CCLINK=$(CXX)
CXXFLAGS= -g -Wall -c -fpic
OBJCPP = ip.cpp field.cpp port.cpp string.cpp
OBJO = ip.o field.o port.o string.o
LIBFIRE = libfirewall.so

export LD_LIBRARY_PATH=./

firewall.exe: $(LIBFIRE) $(OBJO) $(OBJCPP) main.o
	$(CXX)  -g -Wall $(OBJO) main.o -o firewall.exe -L. -lfirewall -L. -linput

libfirewall.so: $(OBJO)
	$(CCLINK) -shared $(OBJO) -o $(LIBFIRE)

port.o: port.cpp port.h field.o
	$(CXX) $(CXXFLAGS)   port.cpp

ip.o:  ip.h ip.cpp field.o
	$(CXX) $(CXXFLAGS)   ip.cpp

field.o: string.cpp  field.cpp field.h
	$(CXX) $(CXXFLAGS)   field.cpp

string.o: string.cpp string.h
	$(CXX) $(CXXFLAGS)   string.cpp

main.o: main.cpp string.h ip.h input.h port.h
		$(CXX) -g -Wall -c -c -fpic main.cpp

clean:
	rm -rf *.o libfirewall.so *.exe
