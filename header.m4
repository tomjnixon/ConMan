dnl Don't output anything until CONFIG_FILE is used.
divert(-1)

dnl Use NEXT_ID and INC_NEXT_ID for generating unique ids.
define(`NEXT_ID', 0)
define(INC_NEXT_ID, `define(`NEXT_ID', incr(NEXT_ID))')

dnl local_config.m4 uses SET_COMPUTER to define the COMPUTER variable.
define(SET_COMPUTER, `define(COMPUTER, $1)')
include(local_config.m4)

dnl config.m4 defines computers and groups, which are defined to either 0 or 1.
define(DEFINE_COMPUTER, `define($1, ifelse(COMPUTER, $1, 1, 0))')
define(DEFINE_GROUP, `define($1, eval($2))')
include(config.m4)

dnl If $1 evaluates to 1, $2, else $3
define(IF_COMPUTER, `ifelse(eval($1), 1, `$2', `$3')')

dnl Hacky conditional sections.
dnl For example:
dnl   ON_COMPUTER(FOO)
dnl   <stuff for computer foo>
dnl   ELSE_COMPUTER()
dnl   <stoff for !foo>
dnl   END_COMPUTER()
define(ON_COMPUTER, `pushdef(`OLD_OUTPUT', divnum)IF_COMPUTER($1, , `divert(-1)')dnl')
define(END_COMPUTER, `divert(OLD_OUTPUT)popdef(`OLD_OUTPUT')dnl')
define(ELSE_COMPUTER, `divert(ifelse(divnum, -1, OLD_OUTPUT, -1))dnl')

dnl The script file contains commands to run. Clear it.
syscmd(echo -n > SCRIPT_FILE)

dnl Add a command to the script file.
define(ADD_TO_SCRIPT, `syscmd(echo "$1" >> SCRIPT_FILE)')

dnl Produce a config file.
dnl Arguments:
dnl   - Config name -- not currently used for anything,
dnl   - File name -- Where to put this section.
dnl   - Enabled (optional) -- Boolean expression; should this be generated?
define(CONFIG_FILE,
`IF_COMPUTER(eval(ifelse($3,,1,$3)),
	`ADD_TO_SCRIPT(config_file NEXT_ID $1 $2)')dnl
ifelse(NEXT_ID, OUTPUT_ID, `divert(0)', `divert(-1)')dnl
INC_NEXT_ID()dnl')
