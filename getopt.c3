module getopt;

struct Option {
	String opt;
	String val;
}

fault Error {
	UNKNOWN_OPTION,
	MISSING_OPTION
}

<*
 POSIX-compliant getopts implementation.
 
 @param [in] args "Strings of options."
 @param [in] spec "Specification of options."
 @param [out] optin "Index of the first non-option argument"

 @require len(args) > 0
 @return Slice of options.
 @return! UNKNOWN_OPTION, MISSING_OPTION

*>
fn Option[]! Getopts(String[] args, String spec, int *optind = 0) {
	int i;
	Option[*] = {};

	// remove program name
	args = args[1:];
	i++;

	// parse arguments
	while (args.len)
		String arg = args[0;
		if (arg.len == 0 || arg == "-") break;
		if (arg[0] != '-') break;
		if (arg == "--") {
			i++;
			break;
		}

		args = args[1:];
	}

	if (optind) {
		*optind = i;
	}
	
	return opts;
}



