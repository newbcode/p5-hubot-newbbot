package Hubot::Scripts::hello;

use utf8;
use strict;
use warnings;
use Text::FIGlet;
use Data::Printer;

sub load {
    my ( $class, $robot ) = @_;
 
    $robot->hear(
        qr/^hello (.+)/i,    
        \&hello,
    );
    $robot->hear(
        qr/^hello list$/i,
        \&hello_list,
    );
    $robot->hear(
        qr/^hello -f (\w+) (.+)/i,
        \&hello_font,
    );

}

sub hello {
    my $msg = shift;

    my @fonts = qw/banner block big bubble digital ivrit lean mini mnemonic
        script shadow slant small smscript smshadow smslant standard term/;

    my $user_input = $msg->match->[0];

    if ($user_input =~ /-f/) {
        return;
    }

    my $num = int( rand(21) );

    my $font = Text::FIGlet->new(-d=>"./figlet", -f=>"$fonts[$num]");
    my $text = $font->figify(-A=>"$user_input");
    $msg->send( split (/\n/, $text) ) if $user_input ne 'list';
}

sub hello_list {
    my $msg = shift;

    my @fonts = qw/banner block big bubble digital ivrit lean mini mnemonic
        script shadow slant small smscript smshadow smslant standard term/;
    my $s_fonts = join ('/ ', @fonts);

    $msg->send('List of available asciifonts - '. $s_fonts );
}

sub hello_font {
    my $msg = shift;

    my $user_font= $msg->match->[0];
    my $user_input= $msg->match->[1];

    my $flag = 'off';
    my @fonts = qw/banner block big bubble digital ivrit lean mini mnemonic
        script shadow slant small smscript smshadow smslant standard term/;

    my $s_fonts = join ('/ ', @fonts);

    for my $font (@fonts) {
        if ($font eq $user_font) {
            my $font = Text::FIGlet->new(-d=>"./figlet", -f=>"$user_font");
            my $text = $font->figify(-A=>"$user_input");
            $msg->send( split (/\n/, $text) ) if $user_input ne 'list';
            $flag = 'on';
        }
    }
    $msg->send("Font($user_font) is not available ...") if $flag eq 'off';
    $msg->send('List of available asciifonts - '. $s_fonts ) if $flag eq 'off';
}
1;

=pod

=head1 Name 

    Hubot::Scripts::hello
 
=head1 SYNOPSIS

    hello <text> - Random text show in ascii
    hello list - Ascii Fonts List
    hello -f <text> - Select Ascii Font to Show.  
 
=head1 AUTHOR

    YunChang Kang <codenewb@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Yunchang Kang.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself
 
=cut
