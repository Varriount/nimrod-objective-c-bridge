import objcbridge/core, strutils

{.passL: "-lobjc".}
{.passL: "-framework AppKit".}
{.emit: """

#include <Foundation/NSObject.h>
#include <stdlib.h>

@interface Greeter: NSObject
{
  char *name_;
}

- (void)greet:(long)x y:(long)dummy;
- (char*)name;
- (void)setName:(char*)name;
+ (void)genericGreeter:(char*)hello;

@end

#include <stdio.h>

@implementation Greeter

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

#include <stdlib.h>
""".}

type
  Greeter {.importc: "Greeter*", header: "<objc/Object.h>", final.} = object
  NSDate* {.importc: "NSDate*", header: "<Foundation/Foundation.h>",
    final.} = object


#dumpTree:
#  proc newModel(): Greeter {.NoStackFrame, inline.} =
#    {.emit: """return [Greeter new];""".}
#  proc greet(self: Greeter, x, y: int) {.importobjc: "greet", nodecl.} = nil
#  proc temp_param(hello: cstring = "papa") = nil
#  #proc genericGreeter(hello: cstring)
#  ##"a"
#  #proc genericGreeter(hello: cstring) =
#  #  {.emit: """[Greeter genericGreeter:`hello`];""".}

import_objc_class(Greeter):
  proc genericGreeter(hello: cstring = "pepe")
  proc greet(self: Greeter, x, y: int)
  proc new(): Greeter
  proc release(self: Greeter)
  proc setName(self: Greeter, name: cstring)

proc tester() =
  genericGreeter("blah" & " and " & "foo")
  genericGreeter()
  let g = newGreeter()
  #var g = newModel()
  g.setName(cstring("foo"))
  g.greet(1, 3)
  g.release()

when defined(objc):
  echo "Hey!"
when isMainModule:
  tester()
