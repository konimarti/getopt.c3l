# getopt in C3

POSIX-compatible implementation of getopt(3) for C3.

### Install

Add the path to the `getopt.c3l` folder to `dependency-search-paths` and
`getopt` to `dependencies` in your `project.json` file:

```json
{
    "dependency-search-paths": ["lib", "<path_to_getopt.c3l_folder>"],
    "dependencies": ["getopt"]
}
```

### Examples

```cpp
// $ c3c compile getopt.c3 examples/getopt.c3 && ./getopt -ab hello -- rest
import posix::getopt;
import std::io;

fn void! main(String[] args) {
	int optind;
	Option[] opts = getopt::temp_getopts(args, "ab:", &optind)!!;
	foreach (opt : opts) {
		switch (opt.flag) {
			case 'a':
				io::printn("flag -a set");
			case 'b':
				io::printfn("flag -b set with argument '%s'", opt.arg);
		}
	}
	if (optind < args.len) {
		io::printfn("positional arguments: %s", args[optind..]);
	}
}

// Output:
// flag -a set
// flag -b set with argument 'hello'
// positional arguments: [rest]
```
