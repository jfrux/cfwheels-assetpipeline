#Asset Pipeline for CFWheels

## Installation
Install [Node.js](http://nodejs.org)<br />
Install [Git](http://git-scm.com/book/en/Getting-Started-Installing-Git)

Open up Terminal / Console.
```
$ cd /path/to/sites_folder/
$ git clone git://github.com/JoshuaIRL/cfwheels-assetpipeline-example.git my-cfwheels-site-name
$ npm install
$ node server
```

## Bugs / Issues
Please visit the primary repo for all issues / bug reports:
[https://github.com/JoshuaIRL/cfwheels-assetpipeline/issues](https://github.com/JoshuaIRL/cfwheels-assetpipeline/issues)

[issues]: https://github.com/JoshuaIRL/cfwheels-assetpipeline/issues

## The Directive Processor
Please read [Mincer](https://github.com/nodeca/mincer/blob/master/README.md) for more information.
Mincer runs the *directive processor* on each CSS and JavaScript
source file. The directive processor scans for comment lines beginning
with `=` in comment blocks at the top of the file.

    //= require jquery
    //= require jquery-ui
    //= require backbone
    //= require_tree .

The first word immediately following `=` specifies the directive
name. Any words following the directive name are treated as
arguments. Arguments may be placed in single or double quotes if they
contain spaces, similar to commands in the Unix shell.

**Note**: Non-directive comment lines will be preserved in the final
  asset, but directive comments are stripped after
  processing. Mincer will not look for directives in comment blocks
  that occur after the first line of code.


### Supported Comment Types

The directive processor understands comment blocks in three formats:

    /* Multi-line comment blocks (CSS, Stylus, JavaScript)
     *= require foo
     */

    // Single-line comment blocks (Stylus, JavaScript)
    //= require foo

    # Single-line comment blocks (CoffeeScript)
    #= require foo


## Mincer Directives

You can use the following directives to declare dependencies in asset
source files.

For directives that take a *path* argument, you may specify either a
logical path or a relative path. Relative paths begin with `./` and
reference files relative to the location of the current file.


### The `require` Directive ###

`require` *path* inserts the contents of the asset source file
specified by *path*. If the file is required multiple times, it will
appear in the bundle only once.


### The `include` Directive ###

`include` *path* works like `require`, but inserts the contents of the
specified source file even if it has already been included or
required.


### The `require_directory` Directive ###

`require_directory` *path* requires all source files of the same
format in the directory specified by *path*. Files are required in
alphabetical order.


### The `require_tree` Directive ###

`require_tree` *path* works like `require_directory`, but operates
recursively to require all files in all subdirectories of the
directory specified by *path*.


### The `require_self` Directive ###

`require_self` tells Mincer to insert the body of the current
source file before any subsequent `require` or `include` directives.


### The `depend_on` Directive ###

`depend_on` *path* declares a dependency on the given *path* without
including it in the bundle. This is useful when you need to expire an
asset's cache in response to a change in another file.


### The `stub` Directive ###

`stub` *path* allows dependency to be excluded from the asset bundle.
The *path* must be a valid asset and may or may not already be part
of the bundle. Once stubbed, it is blacklisted and can't be brought
back by any other `require`.

# Credits
MANY thanks to the team at nodeca for their hard work in porting Sprockets to Node.js! Especially [Aleksey V Zapparov][aleksey]!

[aleksey]: https://github.com/ixti

Great thanks to [Sam Stephenson][sam] and [Joshua Peek][josh] for the Sprockets,
the most awesome and powerfull web assets processor I ever used, and which
became a great source of inspiration (and model of almost all logic behind
Mincer). Special thanks to Joshua for his assistance in hacking into Sprockets
sources.

[sam]:  https://github.com/sstephenson
[josh]: https://github.com/josh


# Mincer Author
[Aleksey V Zapparov][github] (follow [@zapparov][twitter] on twitter).

[github]:   https://github.com/ixti
[twitter]:  https://twitter.com/zapparov