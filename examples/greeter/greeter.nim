import objcbridge/core, objcbridge/NSObject, objcbridge/NSString,
  strutils, macros

# The following compiler pragmas are only required to embed the NSGreeter.m
# code, usually you won't be doing any of this in your program.
block:
  {.passC: "-I.".}
  {.passL: "-lobjc".}
  {.passL: "-framework AppKit".}
  {.compile: "NSGreeter.m".}

# Import the NSGreeter type, along with some procs.
import_objc_class(NSGreeter, """"NSGreeter.h""""):
  proc genericGreeter(hello: cstring = "pepe")
  proc greet(self: NSGreeter, x, y: int)
  proc new*(): NSGreeter
  proc release(self: NSGreeter)
  proc setName(self: NSGreeter, name: cstring)
  proc nsname(self: NSGreeter): NSString

proc tester() =
  var a: NSObject
  let o = newNSObject()
  o.release()

  genericGreeter("blah" & " and " & "foo")
  genericGreeter()
  let g = newNSGreeter()
  g.setName("foo")
  let n = g.nsname
  echo "Nsname length ", n.length
  echo "NSname value '", n, "'"
  g.greet(1, 3)
  g.release()

when isMainModule:
  tester()
