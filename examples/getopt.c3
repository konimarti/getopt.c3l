import posix::getopt;
import posix::command;
import std::io;

fn void! main(String[] args) {

	Command *root = Command{}.init(
		use: "app [commands] [flags]",
		run: fn void!(String[] args, Option[] opts) {
			io::printfn("hello from root with args: %s", args);
		},
		allocator: allocator::temp(),
	);

	root.add_command(
		Command{}.init(
			use: "init [-b]",
			run: fn void!(String[] args, Option[] opts) {
				io::printfn("hello from init with args: %s", args);
			},
			allocator: allocator::temp(),
		).add_flag(
			{.shortopt = 'b', .optarg = true},
		),
	);

	return root.execute(args);

	/*
	int optind;
	Option[] opts = getopt::parse_temp(args, {{.shortopt = 'a'},{.longopt = "block", .optarg = true}}, &optind)!!;
	foreach (opt : opts) {
		switch {
			case opt.flag.shortopt == 'a':
				io::printn("flag -a set");
			case opt.flag.shortopt == 'b' || opt.flag.longopt == "block":
				io::printfn("flag -b set with argument '%s'", opt.arg);
		}
	}
	if (optind < args.len) {
		io::printfn("positional arguments: %s", args[optind..]);
	}
	*/
}
