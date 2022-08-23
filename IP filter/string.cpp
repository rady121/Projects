#include <stddef.h>
#include <iostream>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include "string.h"

using namespace std;

    //empty c'tor//
String::String()
{
    this->data = nullptr;
    this->length = 0;
}

//copy one string to another string using reference//

String::String(const String &str)
{
    length = strlen(str.data);
    data = new char[length+1]();
    strcpy(data,str.data);
}  

//copy one string to another string using clone//

String::String(const char *str)
{
    length = strlen(str);
	data = new char[length+1];
	strcpy(data, str);
}

//d'tor//

String::~String()
{
    delete[] data;
}

//assigning operator of string reference//

String& String::operator=(const String &rhs)
{
	if (&rhs != this)
    {
		delete[] data;							
   		length = rhs.length;
   		data = new char[length+1];
    	strcpy(data,rhs.data);
    }
       return *this;
}

//assigning operator of constant char//

String& String::operator=(const char *str)
{
	int length = strlen(str);
    delete[] data;
    data = new char[length+1];
	strcpy(data,str);
    return *this;
}

//Returns true if the contents of this equals to the content of rhs//

bool String::equals(const String &rhs) const
{
	return (!strcmp(this->data,rhs.data));
}

bool String::equals(const char *rhs) const
{
    return (!strcmp(this->data,rhs));
}

int String::to_integer() const
{
    if (this->data == nullptr) return 0;
    return atoi(this->data);
}

String String::trim() const
{
    char copied_string[length+1];
    int left = 0, right = (int)length - 1;
    strcpy(copied_string,data);

    // counting spaces from the left

	while (copied_string[left] == ' ' && left < right) {
		left++;
	}
	 //counting spaces from the right

	while (copied_string[right] == ' ' && left < right) {
		right--;
	}
	int len_trimed = right-left+1;
	char* clean_string = new char[len_trimed+1]();
   int i = 0;
   while (left <= right){
        clean_string[i] = data[left];
       i++;
      left++;
   }
   clean_string[len_trimed] = '\0';
  String trimed = String(clean_string);
  delete[](clean_string);
  return trimed;
}

void String::split(const char *delimiters, String **output, size_t *size) const
{
    if (delimiters == NULL || size == 0 || this->data == NULL)											//checking validity of recieved parameters
    {
    *size = 0;
        *output = NULL;
        return;
        }
    int splits = 1;
    char tmp_data[((int)length) + 1];
    strcpy(tmp_data,data);
    for(int i = 0; tmp_data[i]!='\0'; i++)
    {
        for(int j = 0; delimiters[j]!='\0'; j++)
        	if (tmp_data[i] == delimiters[j])	splits ++;									//count how many sub string we'll get
    }
    if (output == NULL)
    {
        *size = splits;
        return;
    }
    *output = new String[splits];															//initialize String accordingly
    *size = splits;																			//might be detected as memory leak but we
    int outpu_index = 0;																	//need it outside this function
    int start_of_substring = 0;
    for(int i = 0; tmp_data[i]!='\0'; i++)													//from here on we fill the newly 
    {																						//created String with the wanted substrings
        for(int j = 0; delimiters[j]!='\0'; j++)
        {
            if (delimiters[j] == tmp_data[i])
            {
                if (start_of_substring != i)
                {
                    tmp_data[i] = '\0';
                    (*output)[outpu_index] =String(&tmp_data[start_of_substring]);			
                }
                else	(*output)[outpu_index] =NULL;
                start_of_substring = i+1;
                outpu_index++;
            }
        }
    }
    for(int i = 0; delimiters[i]!='\0'; i++){
        if(tmp_data[((int)length)-1] == delimiters[i])	(*output)[outpu_index] =NULL;
        else	(*output)[outpu_index] =String(&tmp_data[start_of_substring]);
    }
    return;
}
