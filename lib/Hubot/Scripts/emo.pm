package Hubot::Scripts::emo;

use utf8;
use strict;
use warnings;
use Storable;
use Data::Printer;

sub load {
    my ( $class, $robot ) = @_;
 
    $robot->hear(
        qr/(화남|머리아픔|맥주|도망|ping|pong|행복|좀비|댄스|슬픔|사랑|발자국|헬로우|음악|와우|폭격|일출)/i,    
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
            if ( $user_input eq 'ping') {
                $msg->send( split (/\n/, $$emoref{$emo_key}) );
                $msg->send( $sender );
                $flag = 'on';
            }
            elsif ( $user_input eq 'pong') {
                $msg->send( split (/\n/, $$emoref{$emo_key}) );
                $msg->send( '                          '."$sender" );
                $flag = 'on';
            }

            else {
                $msg->send( split (/\n/, $$emoref{$emo_key}) );
                $flag = 'on';
            }
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

ascii emoticons  - This is not command. 

Show the random emoticons.
 
=head1 AUTHOR

    YunChang Kang <codenewb@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Yunchang Kang.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself
 
=cut
