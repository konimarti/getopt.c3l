module posix::command;

import posix::getopt;
import std::collections::list;
import std::io;

def RunFunc = fn void!(String[], Option[]);

struct Command
{
	String use;
	RunFunc run;

	List(<Flag>) flags;
	List(<Command*>) cmds;
	Allocator allocator;
}

fn Command* Command.init(&self, String use, RunFunc run, Allocator allocator)
{
	*self = {.use = use, .run = run, .allocator = allocator};
	self.flags.new_init(4, allocator);
	self.cmds.new_init(4, allocator);
	return self;
}

fn Command* Command.add_flag(&self, Flag f)
{
	self.flags.push(f);
	return self;
}

fn Command* Command.add_command(&self, Command *c)
{
	self.cmds.push(c);
	return self;
}

fn void! Command.execute(&self, String[] args)
{
	int optind;
	Option[] opts = getopt::parse_temp(args, self.flags.to_tarray(), &optind)!;
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

		String arg = args[optind];
		foreach (sub : self.cmds)
		{
			if (sub.use.starts_with(arg))
			{
				io::printfn("execute sub-command: %s", args[optind..]);
				return sub.execute(args[optind..]);
			}
		}
	}
	io::printfn("run command: %s", self.use);
	return self.run(args[optind..], opts);
}
