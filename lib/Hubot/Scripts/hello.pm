package Hubot::Scripts::hello;

use utf8;
use strict;
use warnings;
use Text::FIGlet;

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

    my @fonts = qw/banner block big bubble digital ivrit lean mini mnemonic
        script shadow slant small smscript smshadow smslant standard term/;

    my $user_input = $msg->match->[0];

    my $num = int( rand(21) );

    my $font = Text::FIGlet->new(-d=>"./figlet", -f=>"$fonts[$num]");
    my $text = $font->figify(-A=>"$user_input");
    $msg->send("Font is $fonts[$num]!!!!!!!!!!!!");
    $msg->send( split (/\n/, $text) );
}

1;

=pod

=head1 Name 

    Hubot::Scripts::hello
 
=head1 SYNOPSIS

    hello <text> - Random show text in ascii art
 
=head1 AUTHOR

    YunChang Kang <codenewb@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Yunchang Kang.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself
 
=cut
