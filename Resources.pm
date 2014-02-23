#!/usr/bin/perl -w

use strict ;
use warnings ;
use Log::Log4perl qw(get_logger :levels);
use Data::Dumper ;
use Net::Ping ;
use Config::Auto; # Auto-parser for configuration files

package Resources ;

# Setup Perl-isms for exporting functions of this package
my @Exporter ;
our @ISA=("Exporter") ;

my $logger;
our $debug=0 ;

# Define hash of options
my $options;

my $method='' ;
#my %remote_params={} ;

########################
##
## process_config
##
## Reads the servers.config
## in the application directory
## Populates environment according to config
##
## INPUTS: N/A
## RETURNS: N/A
## PRINTS: N/A
## USES: servers.config file
## 
########################

sub process_config() {
  # Read config
  $logger->info("Opening servers.config");
  $options = Config::Auto::parse("servers.config");
  # Print all options in %options hash to debug log
  $logger->debug(Data::Dumper::Dumper(\$options));
}

push(@Exporter,"process_config") ;

########################
##
## setup
##
## Sets up the environment
## Creates objects for OO bits
## Populates global variables
##
## INPUTS: N/A
## RETURNS: N/A
## PRINTS: N/A
##
########################

sub setup() {
	Log::Log4perl->init('./log4perl.conf') ;
  $logger = Log::Log4perl->get_logger("Resources");
	process_config() ;
}

push(@Exporter,"setup") ;

########################
##
## remote_run
##
## Wrapper subroutine that abstracts the
## remote_run_powerbroker and remote_run_ssh
## functions. Consuming scripts can assume
## RPC just works. The output of the command
## is returned as a vector of strings
##
## INPUTS: (string) remote_server, (string) remote_command
## RETURNS: (array) output
## PRINTS: N/A
## 
########################

sub remote_run($$) {
	##TODO Write remote_run wrapper
	
}

push(@Exporter,"remote_run") ;

########################
##
## remote_run_ssh
##
## Uses slogin to remotely run a
## command. This should not be called
## directly, but instead should be
## wrapped with the remote_run subroutine
##
## INPUTS: (string) remote_server, (string) remote_command
## RETURNS: (array) output
## PRINTS: N/A
## USES: ssh private key, slogin command (invoked via open())
##
########################

sub remote_run_ssh($$) {
	##TODO Write remote_run_ssh method
	
}

push(@Exporter,"remote_run_ssh") ;

########################
##
## remote_run_powerbroker
##
## uses pbrun to remotely run a
## command. This should not be called
## directly, but instead should be wrapped
## by the remote_run subroutine
##
## Note: Because of fragility in PBMASTERD, we
## artificially slow remote_run_powerbroker down
## by adding sleep() calls. Not optimal. 
##
## INPUTS: (string) remote_server, (string) remote_command
## RETURNS: (array) output
## PRINTS: N/A
## USES: pbrun command (invoked via open())
## 
########################

sub remote_run_powerbroker($$) {
	# Parse parms
	my ($remote_server, $remote_command)=@_ ;
	my @output ; # Define local array
	my $ping=Net::Ping->new() ; # Prepare to ping remote, target, server to make sure it's available
	if($ping->ping($remote_server)) { # Ping server to see if it is online
	# Build pbrun command
		my $pbcmd=sprintf(
			"%s%s%s%s%s",
			"/usr/local/bin/pbrun -b -h ",
			$remote_server,
			" /bin/su - root -c \'echo \"__START_OF_RECORD_\" ; ",
			$remote_command,
			"\' 2>/dev/null"
		) ;
		my $cmd_handle ; # Temporary variable to hold handle info
		if (open($cmd_handle,"$pbcmd|")) { # Run command and pipe output
			my $ready=0 ;
			while (my $output_line=<$cmd_handle>) { # Loop through 
				if ($output_line =~ m/__START_OF_RECORD_/) {
					++$ready ;
					next() ;
				}
				if ($ready==0) {
					next() ;
				} else {
					push(@output,$output_line) ;
				}
			}
			
		} else {
			
		}
		
	} else {
		
	}
}

push(@Exporter,"remote_run_powerbroker") ;

########################
##
## get_packages
##
## Uses remote_run to list the
## installed packages in the remote
## server. For now, this is just
## via RPM. If you wanted to get fancy
## you could use this as an interface to
## abstract the dpkg (Debian/Ubuntu) or
## pkg_info (UNIX) or lslpp (AIX)
##
## INPUTS: (string) remote_server
## RETURNS: (array) packages
## PRINTS: N/A
## USES: RPM command
## 
########################

sub get_packages($) {
	
}

push(@Exporter,"get_packages") ;

########################
##
## get_os
##
## Uses remote_run to enumerate
## information about the remote
## server, including OS name, kernel
## version, platform and OS user-space
## version. Because it is expecting RHEL,
## we can make some assumptions.
##
## INPUTS: (string) remote_server
## RETURNS: (hash) os_details
## PRINTS: N/A
## USES: uname, redhat-release
##
########################

sub get_os($) {
	
}

push(@Exporter,"get_os") ;

########################

########################
##
##TODO: Add Server Build
##TODO: Add Query/Update CMDB
##TODO: Add caching
##TODO: This means updating and querying memd
##TODO: That will suck, but it will make faster while taking load off PBMASTERD
##
########################
