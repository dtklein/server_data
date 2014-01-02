#!/usr/bin/perl

use Dancer ;
use Dancer::Serializer::Mutable ;
use Resources;
use strict ;
use warnings ;

my @servers=("prodsas1","prodsas2","prodencsas1") ;
my $srv ;
my $cmd ;

set serializer => 'mutable';

sub remote_run($$) {
    #do stuff
    #wraps pbrun, returns the output as a vector of strings
}


get '/servers/' => sub {
    return(\@servers) ;
} ; 

get '/servers/:srv/reboot' => sub {
    $srv=(param 'srv' || 'unknown') ;
    if ($srv ~~ @servers) {
        remote_run($srv,"/sbin/shutdown -r now") ;
    } else {
        status(404) ;
        $cmd=sprintf("%s%s%s","Server ",$srv," not found") ;
    }
    return($cmd) ;
} ;

get '/servers/:srv/packages' => sub{
    $srv=(param 'srv' || 'unknown') ;
    if ($srv ~~ @servers) {
        my @pkgs=Resources::get_packages($srv) ;
        return(\@pkgs) ;
    } else {
        status(404) ;
        return(sprintf("%s%s%s","Server ",$srv," not found")) ;
    }
} ;

get '/servers/:srv/os' => sub{
    $srv=(param 'srv' || 'unknown') ;
    if ($srv ~~ @servers) {
        my %os=Resources::get_os($srv) ;
        return(\%os) ;
    } else {
        status(404) ;
        return(sprintf("%s%s%s","Server ",$srv," not found")) ;
    }
} ;

Dancer::start() ;
