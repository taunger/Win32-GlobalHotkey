use ExtUtils::testlib;

use strict;
use warnings;

use Win32::GlobalHotkey;

use Test::More tests => 1;

eval {
	my $hk = Win32::GlobalHotkey->new;
	$hk->RegisterHotkey( vkey => 'B', modifier =>  Win32::GlobalHotkey::MOD_ALT, cb => sub{ print 'ALT-B', "\n" } );
	$hk->RegisterHotkey( vkey => 'Q', modifier =>  Win32::GlobalHotkey::MOD_CONTROL |  Win32::GlobalHotkey::MOD_ALT, cb => sub{ print 'CONTROL-ALT-Q', "\n" } );
	$hk->StartEventLoop;
	sleep 1;
	$hk->StopEventLoop;
	sleep 1;
};

if ( $@ ) {
	fail 'standard';	
} else {
	pass 'standard';
}
