use ExtUtils::testlib;

use Win32::GlobalHotkey;
use 5.16.0;
use warnings;
$| = 1;

say for @INC;

use constant {
	MOD_ALT      => 0x0001,
	MOD_CONTROL  => 0x0002,
	MOD_SHIFT    => 0x0004,
	MOD_WIN      => 0x0008,
	MOD_NOREPEAT => 0x4000,
};

#say chr( 0x42 );
#say sprintf( "%x", ord( '0' ) );

#exit;

my $hk = Win32::GlobalHotkey->new;
$hk->RegisterHotkey( vkey => 'B', modifier => MOD_ALT, cb => sub{ say 'ALT-B' } );
$hk->RegisterHotkey( vkey => 'Q', modifier => MOD_CONTROL | MOD_ALT, cb => sub{ say 'CONTROL-ALT-Q' } );
$hk->StartEventLoop;
sleep 10;
$hk->StopEventLoop;

END{
	say '--- END ---';	
}