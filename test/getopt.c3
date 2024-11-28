module getopt_test;

import posix::getopt;

struct TestCase {
	String cmdline;
	Flag[] flags;
	Option[] want;
}

TestCase[] tests = {
	{
		.cmdline = "cmd -a",
		.flags = {{.shortopt = 'a'}},
		.want = {
			{
				.flag = 'a',
				.arg = "",
			},
		},
	},
	{
		.cmdline = "cmd -a",
		.optstring = "ab:",
		.flags = {}{.shortopt = 'a'},
		.want = {
			{
				.flag = 'a',
				.arg = "",
			},
		},
	},
	{
		.cmdline = "cmd -ab hello",
		.optstring = "ab:",
		.want = {
			{
				.flag = 'a',
				.arg = "",
			},
			{
				.flag = 'b',
				.arg = "hello",
			},
		},
	},
	{
		.cmdline = "cmd -b hello",
		.optstring = "ab:",
		.want = {
			{
				.flag = 'b',
				.arg = "hello",
			},
		},
	},
};

macro bool cmp(a, b) {
	return a.flag == b.flag && a.arg == b.arg;
}

fn void test_getopts() @test {
	foreach (t : tests) {
		Option[] opts = getopt::getopts(t.cmdline.tsplit(" "), t.optstring, 
			null, allocator::temp())!!;
		assert(opts.len == t.want.len, "wrong length: got: %d, want: %d", opts.len, t.want.len);
		foreach (i, got : opts) {
			assert(cmp(got,t.want[i]), "wrong option: got: %s, want: %s", got, t.want[i]);
		}
	}
}


