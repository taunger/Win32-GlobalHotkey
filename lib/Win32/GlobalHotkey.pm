package Win32::GlobalHotkey;

use strict;
use warnings;
use threads;
use threads::shared;
use Thread::Cancel;

our $VERSION = '0.01_1';

require XSLoader;
XSLoader::load('Win32::GlobalHotkey', $VERSION);


sub new {
	my ( $class, %p ) = @_;
	
	my $this = bless {}, $class;
	
	$this->{Hotkeys} = [];
	
	return $this;
}

sub RegisterHotkey {
	my ( $this, %p ) = @_;
	
	$p{vkey} = ord $p{vkey};
	
	push @{ $this->{Hotkeys} }, { vkey => $p{vkey}, modifier => $p{modifier}, cb => $p{cb} };
	
	
	1;
}

sub StartEventLoop {
	my $this = shift;
	
	my $CBLog   = $this->{CBLog};
	my @Hotkeys = @{ $this->{Hotkeys} };
	
	$this->{EventLoop} = threads->create(  
		sub {
			
			my %atoms;
			
			for my $hotkey ( @{ $this->{Hotkeys} } ) {
				my $atom = XSRegisterHotkey( 
					$hotkey->{modifier}, 
					$hotkey->{vkey}, 
					'perl_Win32_GlobalHotkey_' . $hotkey->{modifier} . $hotkey->{vkey} 
				);
				
				if ( not $atom  ) {
					# TODO:
					# can not register Hotkey:  - already registered?
				} else {
					$atoms{ $atom } = $hotkey->{cb};
				}				
			}			
						
			while ( my $atom = XSGetMessage( ) ) {
				&{ $atoms{ $atom } };
			}
		}
	);
}

sub StopEventLoop {
	my $this = shift;
	
	#TODO: Unregister / Delete / correct join
	
	#sleep 2;
	$this->{EventLoop}->cancel;
	#$this->{EventLoop}->kill('KILL');
	#$this->{EventLoop}->join;
	#sleep 1;
	
	
	
#	$this->{EventLoop}->join;
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Win32::GlobalHotkey - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Win32::GlobalHotkey;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Win32::GlobalHotkey, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

A. U. Thor, E<lt>a.u.thor@a.galaxy.far.far.awayE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by A. U. Thor

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.16.1 or,
at your option, any later version of Perl 5 you may have available.


=cut
