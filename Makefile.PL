use inc::Module::Install;

name          ( 'HTTP-BrowserSupport'            );
abstract      ( 'Determine support for specific browser features' );
author        ( 'Adam Kennedy<cpan@ali.as>'      );
version_from  ( 'lib/HTTP/BrowserSupport.pm'     );
license       ( 'perl'                           );

requires      ( 'perl'                => '5.005' );
requires      ( 'HTTP::BrowserDetect' => '0'     ); # Fix this

build_requires( 'Test::More'          => '0.47'  );
build_requires( 'File::Spec'          => '0.82'  );

auto_install();

&WriteAll;
