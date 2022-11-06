#import "whisper.h"

#import <Foundation/Foundation.h>

#define CHECK(cond) \
    if (!(cond)) { \
        NSLog(@"[%s:%d] Check failed: %s\n", __FILE__, __LINE__, #cond); \
        exit(1); \
    }

#define CHECK_T(cond) CHECK(cond)
#define CHECK_F(cond) CHECK(!(cond))


int main() {
    // TODO

    return 0;
}
