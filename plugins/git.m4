dnl Clone (and update) a git repo.
dnl Arguments:
dnl   - The path to clone to.
dnl   - The repository url.
define(GIT_REPO, `ifdef(`DISABLE_GIT', `', `ADD_TO_SCRIPT(update_git_repo $1 $2)dnl')')
