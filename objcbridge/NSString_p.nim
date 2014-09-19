import objcbridge/core, objcbridge/NSObject_p, objcbridge/NSString_t,
  strutils, macros, unsigned, unicode

export NSString_t.NSString
export NSString_t.NSStringEncoding
export NSString_t.NSUTF16StringEncoding
export NSString_t.unichar

import_objc_class(NSString, """<Foundation/Foundation.h>"""):
  # Creating and initializing strings
  #varargs won't work, needs to change proc to a macro.
  #proc stringWithFormat*(format: NSString): NSString {.varargs.}
  proc stringWithUTF8String*(bytes: cstring): NSString

  # Getting a String’s Length
  proc length*(self: NSString): uint
  proc lengthOfBytesUsingEncoding*(self: NSString, enc: NSStringEncoding): uint

  proc maximumLengthOfBytesUsingEncoding*(self:
    NSString, enc: NSStringEncoding): uint

  # Getting Characters and Bytes
  proc characterAtIndex*(self: NSString, index: uint): unichar

  # Getting C Strings
  proc getCString*(self: NSString, buffer: ptr char, maxLength: uint,
    encoding:NSStringEncoding): bool
  proc UTF8String*(self: NSString): cstring


# Helper procs to ease conversion to Nimrod.
proc len*(x: NSString): int =
  ## Returns the number of bytes used by the UTF8 representation.
  ##
  ## Use the `length` proc if you are interested in number of characters.
  result = int(x.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))

proc `$`*(x: NSString, safe = false): string =
  ## Returns the nimrod string for `x`.
  ##
  ## If `safe` is true, the proc will return the empty string if the object is
  ## nil. This proc creates a copy, so `x` can be deallocated later without
  ## worries.
  if x.isNil:
    if safe: result = ""
    return
  let mem_space = x.len 
  result = newString(mem_space)
  let ret = x.getCString(addr(result[0]), uint(1 + mem_space),
    NSUTF8StringEncoding)
  assert ret, "Could not get C string for NSString, unicode problem?"

proc `@`*(s: cstring): NSString {.nodecl,exportc.} =
  ## Use like in objc code to create a NSString literal from a plain string.
  {.emit: """@`s`""".}

proc `@@`*(s: cstring): NSString {.inline.} =
  ## Alias for default stringWithUTF8String Nimrod to objc string conversion.
  result = stringWithUTF8String(s)
