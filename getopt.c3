// module getopt implements a POSIX-compliant command-line parser.
module posix::getopt;
import std::collections::list;

struct Option {
	char flag;
	String arg;
}

fault Error {
	UNKNOWN_OPTION,
	MISSING_ARGUMENT
}

<*
 Parses command-line arguments..
 
 @param [in] args "Strings of options."
 @param [in] optstring "Specification of options."
 @param [out] optind "Index of the first non-option argument"

 @require args.len > 0
 @return "Slice of options. Allocated on heap by default."
 @return! Error.UNKNOWN_OPTION, Error.MISSING_ARGUMENT

*>
fn Option[]! getopts(String[] args, String optstring, int *optind, Allocator allocator)
{
	int i;

	List(<Option>) opts;
	opts.temp_init(optstring.len);

	// remove program name
	args = args[1..];
	i++;

	// parse arguments
	while LOOP: (args.len) {
		String arg = args[0];

		switch {
		case arg == "--":
			i++;
			break LOOP;
		case arg == "-":
			break LOOP;
		case arg.len == 0:
		 	break LOOP;
		case arg[0] != '-':
		 	break LOOP;
		}

		arg = arg[1..];
		foreach (c : arg) {
			usz! pos = optstring.index_of_char(c);
			if (catch pos) {
				return Error.UNKNOWN_OPTION?;
			}

			bool hasArgument = pos+1 < optstring.len && optstring[pos+1] == ':';
			if (hasArgument) {
				if (args.len >= 2) {
					args = args[1..];
					i++;
					opts.push({.flag=c, .arg=args[0]});
				} else {
					return Error.MISSING_ARGUMENT?;
				}
			} else {
				opts.push({.flag=c, .arg=""});
			}
		}
		args = args[1..];
		i++;
	}

	if (optind) {
		*optind = i;
	}
	
	return opts.to_new_array(allocator);
}

fn Option[]! new_getopts(String[] args, String optstring, int *optind = null)
{
	return getopts(args, optstring, optind, allocator::heap());
}

fn Option[]! temp_getopts(String[] args, String optstring, int *optind = null)
{
	return getopts(args, optstring, optind, allocator::temp());
}



