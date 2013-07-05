
# Put your own node definitions in this file.

node default {
	# Every node must include the "nci" class.
 	class { "nci": }

 	# The "ssh" class allows the node to be ssh'd into.
	class { "ssh": }
 	
	# The "dircolors" class sets up "ls" colours, and some aliases.
	class { "dircolors": }

	# The "test" class writes to a test file in /puppet/temp
	class { "test": }
	
	# The "elda" class installs elda (Linked Data API)	
	class { "elda": }

 					}


