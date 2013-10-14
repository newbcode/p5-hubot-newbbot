package Hubot::Scripts::emo;

use utf8;
use strict;
use warnings;
use Storable;
use Data::Printer;

sub load {
    my ( $class, $robot ) = @_;
 
    $robot->hear(
        qr/^emo (.+)/i,    
        \&emo_process,
    );
}

sub emo_process {
    my $msg = shift;

    my $user_input = $msg->match->[0];
    my $sender = $msg->message->user->{name};

    my @emos;
    my $emoref = retrieve('emoticons.dat');
    for my $key ( keys %$emoref ) {
        push @emos, $key;
    }
    
    my $flag = 'off';
    for my $emo_key ( @emos ) {
        if ( $user_input eq $emo_key ) {
            $msg->send('--------------' .  $sender . '\'s emoticon' . '--------------');
            $msg->send( split (/\n/, $$emoref{$emo_key}) );
            $flag = 'on';
        }
    }
    my $able = join '/ ', @emos;
    $msg->send('List of available emoticons - ' . $able) if ( $flag eq 'off');
}

1;

=pod

=head1 Name 

    Hubot::Scripts::emo
 
=head1 SYNOPSIS

    emo <emoticon name> - Show Emoticons
 
=head1 AUTHOR

    YunChang Kang <codenewb@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Yunchang Kang.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself
 
=cut
