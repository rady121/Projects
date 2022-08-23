#include "port.h"
#include "string.h"
#include "field.h"
Port::Port(String pattern) : Field(pattern) { }

Port::~Port(){}

bool Port::set_value(String val) {
	String *string_val;
	size_t size;
	val.split("-", &string_val, &size);
	if (size != 2) return false;									//check that we have 2 subs (beginning and end port)
	left_port = string_val[0].to_integer();
    right_port = string_val[1].to_integer();						//from now we checking if port range is valid
    if(left_port>right_port)					return false;
	if(left_port<0 || right_port<0)				return false;
	if(left_port>65535 || right_port>65535)		return false;
	return true;													//this line is reached only if port ranges passes all criteria
}

bool Port::match_value(String packet) const {
    int value = packet.to_integer();								//parse_input uses this function to check if the packet matches the specific field rule
	if((value<=right_port) && (value>=left_port)){
        return true;
	}
	return  false;
}
