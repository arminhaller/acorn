
class xxdiff {

	case $operatingsystem {
		centos, redhat: {
			# Only available in Fedora, ugh.
			# Here is a rebuild courtesy of http://pkgs.org/download/xxdiff
			$xxdiff_el_major = $operatingsystemrelease ? {
				/^5\./ => 5,
				/^6\./ => 6,
			}

			$xxdiff_el_repo = $xxdiff_el_major ? {
				5 => el,
				6 => puias,
			}

			$xxdiff_arch = $architecture ? {
				/i[3456]86/ => $xxdiff_el_major ? { 5 => i386, 6 => i686 },
				default => $architecture,
			}

			package { 'qt3':
				ensure => installed,
			}

			vcsrepo { "/usr/local/xxdiff":
				ensure => present,
				provider => git,
				source => "git@repos.nci.org.au:nci/xxdiff-el-rpms",
			}

			package { 'xxdiff':
				ensure => installed,
				provider => rpm,
				source => "/usr/local/xxdiff/xxdiff-3.2-14.${xxdiff_el_repo}${xxdiff_el_major}.${xxdiff_arch}.rpm",
				require => [ Package['qt3'], Vcsrepo["/usr/local/xxdiff"] ],
			}
		}
		debian, ubuntu: {
			package { 'xxdiff':
				ensure => installed,
			}
		}
		default: {
			notify("Unrecognized operating system for xxdiff")
		}
	}

}

