divert(-1)


define(SET_COMPUTER, `define(COMPUTER, $1)')

include(local_config.m4)

define(DEFINE_COMPUTER, `define($1, ifelse(COMPUTER, $1, 1, 0))')
define(DEFINE_GROUP, `define($1, eval($2))')

include(config.m4)

define(IF_COMPUTER, `ifelse(eval($1), 1, `$2', `$3')')

define(ON_COMPUTER, `pushdef(`OLD_OUTPUT', divnum)IF_COMPUTER($1, , `divert(-1)')dnl')
define(END_COMPUTER, `divert(OLD_OUTPUT)popdef(`OLD_OUTPUT')dnl')
define(ELSE_COMPUTER, `divert(ifelse(divnum, -1, OLD_OUTPUT, -1))dnl')


define(CONFIG_FILE,
	`define(CONFIG_NAME, $1)define(FILE_NAME, $2)define(ENABLED, eval(ifelse($3,,1,$3)))dnl')

define(GIT_REPO, `syscmd(echo "update_git_repo $1 $2" >> SCRIPT_FILE)')

divert(0)dnl
