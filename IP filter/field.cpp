#include "ip.h"
#include "port.h"
#include "field.h"
#include <string.h>

using namespace std;

Field::Field(String pattern) {                                     //constructor using the overridden string copy constructor
    this->pattern = pattern;
}

Field::~Field(){}                                                 //destructor

bool Field::match(String packet)                                  //checks if packet matches the field rule
{
	String *sub_strings;
    size_t num_of_sub_strings;
    bool result=0;
    String *field_vals;
    
	packet.split(",", &sub_strings, &num_of_sub_strings);
    for(int i = 0; i < int(num_of_sub_strings) ; i++){			//here we split each field of packet to parse the value according to rule value
		size_t size_of_field_vals = 0;
		sub_strings[i].split("=", &field_vals, &size_of_field_vals);
		if(pattern.equals(field_vals[0]))	result = match_value(field_vals[1]);
    }
	return result;
}
