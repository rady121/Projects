#include "string.h"
#include "field.h"

class Ip : public Field {
private:
   int rule, rule_bits;
   String ip_pattern;

protected:
    String sub_field;
   bool match_value(String packet) const;
public:
    Ip(String pattern);
    ~Ip();
    bool set_value(String val);
};
