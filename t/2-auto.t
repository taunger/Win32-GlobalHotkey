use ExtUtils::testlib;

use strict;
use warnings;

use Win32::GlobalHotkey;

use Test::More;

BEGIN {
	eval "use Win32::GuiTest";
	if( $@ ) {
		plan skip_all => "Win32::GuiTest required for testing" 
	} else {
		plan tests => 1;
	}
}


eval {
	my $hk = Win32::GlobalHotkey->new;
	$hk->RegisterHotkey( vkey => 'B', modifier =>  Win32::GlobalHotkey::MOD_ALT, cb => sub{ print 'ALT-B', "\n" } );
	$hk->RegisterHotkey( vkey => 'Q', modifier =>  Win32::GlobalHotkey::MOD_CONTROL |  Win32::GlobalHotkey::MOD_ALT, cb => sub{ print 'CONTROL-ALT-Q', "\n" } );
	$hk->StartEventLoop;
	
	Win32::GuiTest->import( qw( SendKeys ) );
	
	SendKeys( '%b' );
	SendKeys( '^%q' );
	
	$hk->StopEventLoop;
};

if ( $@ ) {
	fail 'standard';	
} else {
	pass 'standard';
}
