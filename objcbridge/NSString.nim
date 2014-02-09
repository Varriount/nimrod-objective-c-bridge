import objcbridge/core, objcbridge/NSObject, strutils, macros, unsigned

type
  NSStringEncoding* = enum
    NSASCIIStringEncoding = 1,
    NSNEXTSTEPStringEncoding = 2,
    NSJapaneseEUCStringEncoding = 3,
    NSUTF8StringEncoding = 4,
    NSISOLatin1StringEncoding = 5,
    NSSymbolStringEncoding = 6,
    NSNonLossyASCIIStringEncoding = 7,
    NSShiftJISStringEncoding = 8,
    NSISOLatin2StringEncoding = 9,
    NSUnicodeStringEncoding = 10,
    NSWindowsCP1251StringEncoding = 11,
    NSWindowsCP1252StringEncoding = 12,
    NSWindowsCP1253StringEncoding = 13,
    NSWindowsCP1254StringEncoding = 14,
    NSWindowsCP1250StringEncoding = 15,
    NSISO2022JPStringEncoding = 21,
    NSMacOSRomanStringEncoding = 30,
    NSProprietaryStringEncoding = 65536,
    NSUTF32StringEncoding = 0x8c000100,
    NSUTF16BigEndianStringEncoding = 0x90000100,
    NSUTF16LittleEndianStringEncoding = 0x94000100,
    NSUTF32BigEndianStringEncoding = 0x98000100,
    NSUTF32LittleEndianStringEncoding = 0x9c000100

const
    NSUTF16StringEncoding* = NSUnicodeStringEncoding

import_objc_class(NSString, """<Foundation/Foundation.h>"""):
  # Creating and initializing strings
  #varargs won't work, needs to change proc to a macro.
  #proc stringWithFormat*(format: NSString): NSString {.varargs.}
  proc stringWithUTF8String*(bytes: cstring): NSString

  # Getting a String’s Length
  proc length*(self: NSString): uint
    ## Returns the number of Unicode characters in the receiver

  proc lengthOfBytesUsingEncoding*(self: NSString, enc: NSStringEncoding): uint
  proc UTF8String*(self: NSString): cstring

  proc getCString*(self: NSString, buffer: ptr char, maxLength: uint,
    encoding:NSStringEncoding): bool


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

proc `@`*(s: cstring): NSString {.nodecl,NoStackFrame,exportc.} =
  ## Use like in objc code to create a NSString literal from a plain string.
  {.emit: """@`s`""".}

proc `@@`*(s: cstring): NSString {.inline.} =
  ## Alias for default stringWithUTF8String Nimrod to objc string conversion.
  result = stringWithUTF8String(s)
