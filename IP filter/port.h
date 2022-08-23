#ifndef PORT
#define PORT

#include "string.h"
#include "field.h"

class Port : public Field {
private:

protected:
    bool match_value(String packet) const;
public:
    int left_port;
    int right_port;
    Port(String pattern);
    ~Port();
    bool set_value(String val);
    bool match(String packet);
};

#endif
