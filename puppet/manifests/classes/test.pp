#test command
class test{

#Base directory for puppet
$PUPPETDIR="/puppet"

#timestamp
$timestamp = generate('/bin/date', '+%Y%d%m_%H:%M:%S')

file {"testfile":
 path => "${PUPPETDIR}/temp/testfile",
 ensure => present,
 mode => 0640,
 content => "I'm a test file. Last edited: ${timestamp} .",
}

}
