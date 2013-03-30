ConMan: Configuration-file Manager
==================================

ConMan is tool for managing dotfiles and other config files on multiple unix
systems, each requiring largely the same set of files but with minor changes in
each location. The system is built on the m4 macro processor which is widely
installed and reasonably powerful.

Tutorial
--------

Configuration/dot file templates should be placed in ``ConMan/configs/*.m4``. In
the simplest case this requires just a single modification. For example::
	
	CONFIG_FILE(my bash rc, ~/.bashrc)
	
	# bashrc continues as-per-normal below...

This defines the contents of ``~/.bashrc`` for all machines. Nice and straight
forward. Note: as this is still a 'normal' m4 script you must ensure that
templates don't accidentally trigger any m4 functionality.

Obviously this isn't very useful as we want to make things only appear for
certain machines. Say we have a config file we only want on machines in my
university department, we can make the config file conditional like so::
	
	CONFIG_FILE(ARCADE Settings, ~/.arcaderc, UNI)
	
	# ...configuration file for some university software here...

The extra argument here (``UNI``) is an expression saying which computers this
file should be present on. See the 'Defining Computers' section to see how you
define these names.

Given that your dotfiles are also now in m4 you can use other macros to clean up
your configs. Some macros are provided by ConMan to help make fine-grain
conditional inclusion easier::
	
	CONFIG_FILE(Example File, ~/.examplerc)
	
	These lines appear on all computers (as usual).
	
	ON_COMPUTER(LAPTOP)
		These lines only appear on my laptop's version of exaple RC.
		How lovely!
	ELSE_COMPUTER()
		These lines only appear on other computers' versions.
	END_COMPUTER()
	
	IF_COMPUTER(LAPTOP|UNI_RESEARCH_DOMAIN,
		`only appears on laptop & uni on the research domain',
		`appears everywhere else')

Finally, it is also worth noting that you can have multiple files defined in one
template. For example, your bashrc and bashprofile all in one template::
	
	CONFIG_FILE(my bashrc, ~/.bashrc)
	
	# Stuff from your bashrc goes here. Maybe you define/use some handy m4 macros?
	
	CONFIG_FILE(my bashprofile, ~/.bashprofile)
	
	# Stuff for the bash profile goes here (still the same file!). Maybe you can
	# use some of those handy macros again here too?

Defining Computers
``````````````````

A list of all the computers which your config files might apply to should be
defined in the 'global' configuration file ``ConMan/config.m4`` like so::
	
	DEFINE_COMPUTER(LAPTOP)
	DEFINE_COMPUTER(DESKTOP)
	DEFINE_COMPUTER(UNI_TEACHING_DOMAIN)
	DEFINE_COMPUTER(UNI_RESEARCH_DOMAIN)

It is also possible to group combinations of computers (and groups) under a
common label. For example, you can add::
	
	DEFINE_GROUP(PERSONAL, LAPTOP | DESKTOP)
	DEFINE_GROUP(UNI,      UNI_RESEARCH_DOMAIN | UNI_TEACHING_DOMAIN)

Each computer also has a 'local' configuration file ``ConMan/local_config.m4``
which simply defines which computer this actually is::
	
	SET_COMPUTER(LAPTOP)

One More Thing: Git Repo Fetching
`````````````````````````````````

A macro ``GIT_REPO(local_dir, repo_url)`` has been provided which requests the
given git repo is kept up-to-date. For example, here it is fetching various VIM
plugins::
	
	CONFIG_FILE(my vim configs, ~/.vimrc)
	
	" stuff for my .vimrc goes here as usual
	
	GIT_REPO(~/.vim/bundle/pathogen, git://github.com/tpope/vim-pathogen.git)
	GIT_REPO(~/.vim/bundle/fugitive, git://github.com/tpope/vim-fugitive.git)
	GIT_REPO(~/.vim/bundle/ctrlp,    git://github.com/kien/ctrlp.vim.git)

Health Warnings
---------------

There are a few thins you should be aware of when using ConMan. Hopefully these
should be resolved over time but for now...

1. It is worth mentioning a second time: your templates are just regular m4 and so
   must be careful to avoid any keywords etc. A list of extra keywords to avoid due
   to ConMan can be found by reading its source (sorry...).

2. Your m4 templates actually get parsed 1+n times (where n is the number of config
   files defined within it). This is due to the current bodge being used to get
   multiple files (and their file names) out of an m4 file. This may change to use
   a different bodge at some time in the future which solves this...

3. Be very careful using m4's ``divert`` command in your m4 scripts... Hopefully
   this will be cleaned up in the future...
  
4. Though the git support presently is a bit random and hard-coded at present, a
   plugin system is (possibly) coming so expect this sort of capability to get
   cleaned up and extended.
