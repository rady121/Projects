#include "ip.h"
#include "string.h"
#include "field.h"

using namespace std;

Ip::Ip(String string) : Field(string)
{
	this->rule_bits=0;
    ip_pattern=string;
}

Ip::~Ip() {
}


int int_to_bin(String ip)                                               //this function takes all 4 segments
{                                                                       //of a field and merges them into one
    String *segments_of_ip;												//by placing each segment in its right
    unsigned int full_ip_rule = 0;										//set of bits
    size_t num_of_segments;
   ip.split(".", &segments_of_ip, &num_of_segments);
    for (int i=0;i<4;i++){
        unsigned int ip_bin = segments_of_ip[i].to_integer();
        if (i==0)	full_ip_rule = ip_bin;								//first segment does not need shifting 
        else{
            full_ip_rule = full_ip_rule << 8; 							//for every other segment we shift 8 bits 
            full_ip_rule = full_ip_rule | ip_bin;						//because max accepted value is 255
        }
    }
    return full_ip_rule;
}

bool Ip::set_value(String val)             							 	//checking if rule is valid
{
   String *sub_strings;
   size_t sub_strings_number;
   val.split("/", &sub_strings, &sub_strings_number);            	 	//split using delimeter
   if ( (int)sub_strings_number != 2)	return false;			 	 	//checking validity of rule
   
   this->rule=sub_strings[1].to_integer();             					//check if the rule is valid number of bits
   if ( (rule < 0) || (rule > 32) )   return false;
   unsigned int temp_rule_bits = int_to_bin(sub_strings[0]);
   rule_bits = temp_rule_bits>>(32 - rule);
   return true;
}

bool Ip::match_value(String packet) const
{
    unsigned int bin_packet = int_to_bin(packet);						//converts packet to its binary version
    bin_packet = bin_packet >> (32-rule);								//keeps bits we are interested in comparing
    if ((bin_packet ^ rule_bits) == 0) return true;
    return false;
}
