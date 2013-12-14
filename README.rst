=========================
Nimrod Objective-C bridge
=========================

This is a module for the `Nimrod programming language
<http://nimrod-lang.org>`_.  Its purpose is to provide macros and some pre
wrapped Objective-C classes to interact with iOS or MacOSX code. The module is
only tested against Apple's environment, but nothing depends on it. You should
be able to interact with `GNUStep <https://en.wikipedia.org/wiki/GNUstep>`_
equally without problems.


License
=======

`MIT license <LICENSE.rst>`_.


Installation
============

Stable version
--------------

Use `Nimrod's babel package manager <https://github.com/nimrod-code/babel>`_ to
install the package::

    $ babel update
    $ babel install objcbridge

Development version
-------------------

Use `Nimrod's babel package manager <https://github.com/nimrod-code/babel>`_ to
install locally the github checkout::

    $ git clone https://github.com/gradha/nimrod-objective-c-bridge.git
    $ cd nimrod-objective-c-bridge
    $ git checkout develop
    $ babel install


Usage
=====

Use ``import objcbridge/core`` in your source code to have access to the core
macros allowing interaction between Objective-C and Nimrod code. For an example
showing how to call both static and instance methods, see
`examples/greeter/README.rst <examples/greeter/README.rst>`_ and the
implementation files in that directory.


Documentation
=============

Documentation is still sparse. You can run the ``doc`` `nakefile task
<https://github.com/fowlmouth/nake>`_ to generate first an HTML version of all
available docs. Unix example::

    $ cd `babel path objcbridge`
    $ nake doc
    $ open docindex.html

Once you have done that, browsing `docindex file <docindex.rst>`_ will allow
you to see all the included documentation. However, for the moment looking at
the provided `examples directory <examples>`_ is your best bet.


Changes
=======

This is version 0.3.1. For a list of changes see the `docs/CHANGES.rst file
<docs/CHANGES.rst>`_.


Git branches
============

This project uses the `git-flow branching model
<https://github.com/nvie/gitflow>`_. Which means the ``master`` default branch
doesn't *see* much movement, development happens in another branch like
``develop``. Most people will be fine using the ``master`` branch, but if you
want to contribute something please check out first the ``develop`` branch and
do pull requests against that.


Feedback
========

You can send me feedback through `github's issue tracker
<https://github.com/gradha/nimrod-objective-c-bridge/issues>`_. I also take a
look from time to time to `Nimrod's forums <http://forum.nimrod-lang.org>`_
where you can talk to other nimrod programmers.
