import objcbridge/core, objcbridge/NSObject, objcbridge/NSString,
  strutils, macros

# Force this to compile on macosx form the commandline.
block:
  {.passL: "-lobjc".}
  {.passL: "-framework AppKit".}

const
  normal_string = "Nimrod string"

proc tester() =
  var a: NSString = @"brakalar literal string"
  echo a
  #a = stringWithFormat(@"Hello %s", normal_string)
  #echo a

when isMainModule:
  tester()
