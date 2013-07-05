
class graphviz-python {
	include python

	$graphviz_python = $operatingsystem ? {
			centos => 'graphviz-python',
			redhat => 'graphviz-python',
			debian => undef,
			ubuntu => undef,
			default => undef,
		}

	package { $graphviz_python:
		ensure => installed,
		alias => graphviz-python,
	}

}

