#include "port.h"
#include "ip.h"
#include "input.h"
#include <cstring>
#include <iostream>

extern int check_args(int, char**);									 //defining external functions from shared library
extern void parse_input(Field &);
using namespace std;
	
int main(int argc, char **argv)
{
   if (check_args(argc, argv))   return -1;               			 //checking if arguments are valid
   String rule(argv[1]);                                  			 //constructing a string with the rule
   String *rule_subs;
   size_t num_of_subs=0;
   rule.split("=", &rule_subs, &num_of_subs);              			//splitting rule to define pattern and value
 	if ( (int)num_of_subs !=2 )
    {
 	   delete[](rule_subs);
	   return -1;
    }
	if ( (rule_subs[0].equals("src-ip")) || (rule_subs[0].equals("dst-ip")))			// check if port or ip then create specific inheritance
    {																					//after initializing inherited class we parse accordingly
   		Ip ip(rule_subs[0]);
   		ip.set_value(rule_subs[1]);
   		parse_input(ip); 
    }
	else if ( (rule_subs[0].equals("src-port")) || (rule_subs[0].equals("dst-port")))
	{
		Port port(rule_subs[0]);
        port.set_value(rule_subs[1]);
	    parse_input(port);
	}
   return 0;
}
