divert(-1)

define(DUMP_VAR, `syscmd(echo "$1=\"$2\"" >> VARS_FILE)')
DUMP_VAR(config_name, CONFIG_NAME)
DUMP_VAR(file_name, FILE_NAME)
DUMP_VAR(enabled, ENABLED)

