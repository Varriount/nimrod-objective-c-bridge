=========================================
Nimrod Objective-C bridge greeter example
=========================================

This is a rewrite of the `Nimrod provided gnustepex.nim
<https://github.com/Araq/Nimrod/blob/master/examples/objciface/gnustepex.nim>`_
example. This version has been modified to compile on MacOSX using Apple's
frameworks, but it is still easy to turn it back to GNUStep if you wish for.

This version shows a more real life example, where you have a class
(``NSGreeter``) available through a header file and you want to call its
methods. Notice how the macro generates the correct code for both instance and
static methods. This is done looking at the name of the first parameter. If it
is named ``self``, the method is considered to be an instance method. This goes
well with Nimrod's object oriented nature where the first parameter is used for
the dot syntax notation.

The file `NSGreeter.m <NSGreeter.m>`_ and its related header file contain the
implementation of a normal Objective-C class.  The file `ex_greeter.nim
<ex_greeter.nim>`_ contains the Nimrod code calling this class.
