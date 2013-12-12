#include <Foundation/NSObject.h>

@interface NSGreeter: NSObject
{
	char *name_; // Avoid NSStrings in this example.
}

- (void)greet:(long)x y:(long)dummy;
- (char*)name;
- (void)setName:(char*)name;

+ (void)genericGreeter:(char*)hello;

@end
