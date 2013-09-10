package Hubot::Scripts::texttrans;

use utf8;
use strict;
use warnings;

sub load {
    my ( $class, $robot ) = @_;
    my @msgs;

    $robot->catchAll(
        sub {
            my $msg = shift;

            my $user_name = $msg->message->user->{name};
            my $user_msg = $msg->message->text;

            push @msgs, "$user_name "."$user_msg";
        }
    );

    $robot->hear (
        qr/^s\/(.*?)\/(.*?)\/$/i,

        sub {
            my $msg = shift;
            my @replace_wr;

            my $sender = $msg->message->user->{name};
            my $before_wr = $msg->match->[0];
            my $after_wr = $msg->match->[1];

            for my $sender_p ( @msgs ) {
                if ( $sender_p =~ /^$sender .*?$before_wr.*?/ ) { 
                    $sender_p =~ s/$before_wr/$after_wr/;
                    push @replace_wr, $sender_p; 
                }
            }
            $msg->send($replace_wr[$#replace_wr]);
        }
    );
}

1;

=pod

=head1 Name 

    Hubot::Scripts::texttrans
 
=head1 SYNOPSIS

    s/<regexp>/<replacement>/ - Search for a character, and then are replaced.

=head1 AUTHOR

    YunChang Kang <codenewb@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Yunchang Kang.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself
 
=cut
