package Hubot::Scripts::cpan;

use utf8;
use strict;
use warnings;
use Encode;
use LWP::UserAgent;
use Data::Printer;

sub load {
    my ( $class, $robot ) = @_;

    $robot->hear(
        qr/(\w+::\w+)/i,    
        \&cpan_serach,
    );


}

sub cpan_serach {
    my $msg = shift;
    my $user_input = $msg->match->[0];

    my $ua = LWP::UserAgent->new;

    my $rep = $ua->get("https://metacpan.org/search?q=$user_input");
   
    if ($rep->is_success) {
        my ( $title, $desc, $author, $release, $relatize );
        if ( $rep->decoded_content =~ m{<a href="/module/$user_input">$user_input</a>(.*?)$}gsm ) { $title = $1; }
        if ( $rep->decoded_content =~ m{<p class="description">(.*?)</p>}gsm ) { $desc = $1; }
        if ( $rep->decoded_content =~ m{<a class="author" href="/author/.*?">(.*?)</a><a href=".*?">(.*?)</a>}gsm ) {
           $author = $1;
           $release = $2;
        }
        if ( $rep->decoded_content =~ m{<span class="relatize">(.*?)</span>}gsm ) { $relatize = $1; }

        if ( $title ) {
            $desc =~ s/&quot\;/"/g; 
            $desc =~ s/&gt\;/>/g;
            $msg->send("$user_input - [$title]");
            $msg->send("Desription  - [$desc] ");
            $msg->send("Author - [$author]"." Release:[$release] - [$relatize]");
        }
    }
    else {
        die $rep->status_line;
    }
}

1;

=pod

=head1 Name 

    Hubot::Scripts::cpan
 
=head1 SYNOPSIS

    cpan module search.
    cpan <module name>.

=head1 AUTHOR

    YunChang Kang <codenewb@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Yunchang Kang.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself
 
=cut
