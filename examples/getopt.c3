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
