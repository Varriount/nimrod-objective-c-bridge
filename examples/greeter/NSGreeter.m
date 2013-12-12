#include "NSGreeter.h"

#include <stdio.h>
#include <stdlib.h>

@implementation NSGreeter

- (void)dealloc
{
	free(name_);
	[super dealloc];
}

+ (void)genericGreeter:(char*)text
{
	printf("Generic hello %s!\n", text);
}

- (void)greet:(long)x y:(long)y
{
	printf("Hello, World!\nx:%ld y:%ld\n", x, y);
	printf("I'm %s\n", name_);
}

- (char*)name
{
	return name_;
}

- (void)setName:(char*)name
{
	free(name_);
	if (name)
		name_ = strdup(name);
	else
		name_ = nil;
}

@end
