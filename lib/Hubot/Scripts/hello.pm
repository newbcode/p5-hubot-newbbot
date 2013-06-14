package Hubot::Scripts::hello;

use utf8;
use strict;
use warnings;

sub load {
    my ( $class, $robot ) = @_;
 
    $robot->hear(
        qr/^hello (.+)/i,    
        \&hello,
    );
}

sub hello {
    my $msg = shift;

    my $sender = $msg->message->user->{name};
    $msg->send($sender);

    my @fonts = qw/banner block big bubble digital ivrit lean mini mnemonic
        script shadow slant small smscript smshadow smslant standard term
        letter mini mnemonic smascii12 smascii9/;

    my $user_input = $msg->match->[0];

    my $num = int( rand(21) );

    my $msg1 = `figlet -f $fonts[$num] $user_input`;
    $msg->send("Font is $fonts[$num]!!!!!!!!!!!!");
    $msg->send( split (/\n/, $msg1) );
}

1;

=pod

=head1 Name 

    Hubot::Scripts::weather
 
=head1 SYNOPSIS
 
    weather <city name>  - View current local area weather information. 
    weather weekly <city name> - View weekly local area weather information.
    weather weekly <city name1> <city name2>... - View weekly local areas weather information.
    weather forecast <local name> - View local weather forecast information. (ex: KangWon-Do, Gyeonggi-Do ..)

=head1 AUTHOR

    YunChang Kang <codenewb@gmail.com>
 
=cut
