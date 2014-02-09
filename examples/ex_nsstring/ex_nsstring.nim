import objcbridge/core, objcbridge/NSObject, objcbridge/NSString,
  strutils, macros, unicode

# Force this to compile on macosx form the commandline.
block:
  {.passL: "-lobjc".}
  {.passL: "-framework AppKit".}

const
  normal_string = "hello '$1' literal string"
  utf8 = "Ñaca"

proc tester() =
  var a: NSString = @normal_string
  echo a
  a = @@(normal_string % "Yaya!")
  echo a
  a = @utf8

  echo "Max num of bytes to hold '", a, "' in UTF8 is ",
    a.maximumLengthOfBytesUsingEncoding(NSUTF8StringEncoding)
  echo "The actual UTF8 bytes needed are ", a.len
  echo "The number of characters is ", a.length
  echo "First char is ", int(a.characterAtIndex(0))

when isMainModule:
  tester()
