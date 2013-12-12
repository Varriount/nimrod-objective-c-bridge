import objcbridge/core, strutils

{.passC: "-I.".}
{.passL: "-lobjc".}
{.passL: "-framework AppKit".}
{.compile: "NSGreeter.m".}

type
  NSGreeter {.importc: "NSGreeter*", final, header: """"NSGreeter.h"""".} = object


import_objc_class(NSGreeter, ""):
  proc genericGreeter(hello: cstring = "pepe")
  proc greet(self: NSGreeter, x, y: int)
  proc new(): NSGreeter
  proc release(self: NSGreeter)
  proc setName(self: NSGreeter, name: cstring)

proc tester() =
  genericGreeter("blah" & " and " & "foo")
  genericGreeter()
  let g = newNSGreeter()
  g.setName("foo")
  g.greet(1, 3)
  g.release()

when isMainModule:
  tester()
