#!/usr/bin/perl -w

# Load testing for HTTP::BrowserSupport

use strict;
use lib ();
use UNIVERSAL 'isa';
use File::Spec::Functions ':ALL';
BEGIN {
	$| = 1;
	unless ( $ENV{HARNESS_ACTIVE} ) {
		require FindBin;
		chdir ($FindBin::Bin = $FindBin::Bin); # Avoid a warning
		lib->import( catdir( updir(), updir(), 'modules') );
	}
}

use Test::More tests => 1;
use HTTP::BrowserSupport ();

my $Browser = HTTP::BrowserSupport->new;
isa_ok( $Browser, 'HTTP::BrowserSupport' );

exit(0);
