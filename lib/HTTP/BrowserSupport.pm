package HTTP::BrowserSupport;

=pod

=head1 NAME

HTTP::BrowserSupport - Determine support for specific browser features

=head1 SYNOPSIS

  # Get a BrowserSupport object
  use HTTP::BrowserSupport ();
  my $Browser = HTTP::BrowserSupport->new;
  
  # Does the browser support window.sizeToContent
  unless ( $Browser->javascript_window_sizeToContent ) {
  	die "Your browser does not support window.sizeToContent";
  }
  
  # The same thing as a static method
  unless ( HTTP::BrowserSupport->javascript_window_sizeToContent ) {
  	die "Your browser does not support window.sizeToContent";
  }
  
  # The same thing as a function
  unless ( HTTP::BrowserSupport::javascript_window_sizeToContent() ) {
  	die "Your browser does not support window.sizeToContent";
  }
  
  # The same thing as an imported function
  use HTTP::BrowserSupport 'javascript_window_sizeToContent';
  unless ( javascript_window_sizeToContent() ) {
  	die "Your browser does not support window.sizeToContent";
  }

=head1 DESCRIPTION

HTTP::BrowserSupport is an proof of concept module which attempts to
determine the capabilities of the browser (specifically in the area
of JavaScript support) based on its brosser string.

This initial version contains a sample implementation and a small set
of three sample functions. This implementation is not scalable at all,
with the tests implemented directly in code, and only for Netscape and
IE.

Longer term, this module would need to become primarily a data product,
with some form of feature database that is accessed and tests compiled
as-needed to do the testing.

Uses of this would include testing for individual required features, or
testing for a set of features required to implement an application.

Rather than a coarse set of "is IE > 4" tests, you should be able to
assemble a custom test for the specific required features. (Unless of
course they are faking their UserAgent, but that is their problem).

=head1 METHODS

=cut

use strict;
use UNIVERSAL 'isa';
use HTTP::BrowserDetect ();

use vars qw{$VERSION};
BEGIN {
	$VERSION = '0.000_01';
}





#####################################################################
# Constructor

=pod

=head2 new

Creates a new HTTP::BrowserSupport object. If provided any arguments,
they will be passed directly to the L<HTTP::BrowserDetect> constructor.

Each HTTP::BrowserSupport object uses a HTTP::BrowserDetect object
internally to provide the basic browser-detection service.

In theory, if not passed any arguments it will use the "current" CGI
object.

Returns a new HTTP::BrowserDetect object, or dies if unable to create
an object.

=cut

sub new {
	my $class = shift;
	my $Browser = HTTP::BrowserDetect->new(@_);

	# Create the object
	my $self = bless {
		Browser => $Browser,
		}, $class;

	$self;
}

sub self {
	return shift if isa(ref $_[0], __PACKAGE__);
	__PACKAGE__->new(@_) or die 'Failed to create BrowserDetect object';
}

=pod

=head2 browser $name [, $version ]

This is the main work-horse method of HTTP::BrowserSupport. The C<browser>
method takes the name (as used in L<HTTP::BrowserDetect>) of a browser and
an optional minimum version number, and attempts to determine if the
current browser matches.

Returns true if the browser matches and the version of the browser is
greater than the required verion, or false otherwise.

=cut

sub browser {
	my $self    = shift;
	my $browser = shift;
	return '' unless $self->{Browser}->$browser();
	return 1  unless defined $_[0];
	$self->{Browser}->version > shift;
}





#####################################################################
# Detection Methods

=pod

=head2 javascript_screen

Does the browser support the root JavaScript 'screen' object.

=cut

sub javascript_screen {
	my $self = self(@_);
	   $self->browser('netscape', 4)
	or $self->browser('ie', 4);
}

=pod

=head2 javascript_window_sizeToContent

Does the browser support the window.sizeToContent method

=cut

sub javascript_window_sizeToContent {
	my $self = self(@_);
	$self->browser('netscape', 6);
}

=pod

=head2 javascript_window_screen

Does the browser support the window.screen property

=cut

sub javascript_window_screen {
	my $self = self(@_);
	   $self->browser('netscape', 6)
	or $self->browser('ie', 4);
}

1;

=pod

=head1 TO DO

- Implement the thousand method we need to detect everything

- Add some form of AutoLoader or compile-on-demand system to avoid the
module bloating out to infinite.

- Create some sort of database to store the specification, turning the
module largely into data product.

=head1 SUPPORT

Bugs should be reported via the CPAN bug tracker at

L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=HTTP%3A%3ABrowserSupport>

For other issues, contact the author.

Please be aware that this is largely an experimental implementation at
this point and while I am happy to add new tests, or correct old ones,
the implementation is likely to change dramatically over time.

=head1 AUTHORS

Adam Kennedy (Maintainer), L<http://ali.as/>, cpan@ali.as

=head1 COPYRIGHT

Copyright (c) 2004 Adam Kennedy. All rights reserved.
This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut
