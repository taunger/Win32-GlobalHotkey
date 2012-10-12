use ExtUtils::testlib;

use strict;
use warnings;

use threads;
use threads::shared;

use Win32::GlobalHotkey;

use Test::More;

eval "use Win32::GuiTest";
plan skip_all => "Win32::GuiTest required for testing" if $@;



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



    
