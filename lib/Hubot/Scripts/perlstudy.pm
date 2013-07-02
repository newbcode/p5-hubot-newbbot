package Hubot::Scripts::perlstudy;

use utf8;
use strict;
use warnings;
use Encode;
use LWP::UserAgent;
use Data::Printer;
use AnyEvent::DateTime::Cron;

my $cron = AnyEvent::DateTime::Cron->new(time_zone => 'local');

sub load {
    my ( $class, $robot ) = @_;
    my $flag = 'off';
 
    $robot->hear(
        qr/^perlstudy:? on *$/i,    
        sub {
            my $msg = shift;
            my $user_input = $msg->match->[0];
            $msg->send('It has been started monitoring [cafe-perlstudy]...');

            $cron->add ( '*/10 * * * *' => sub {
                    $msg->http("http://cafe.rss.naver.com/perlstudy")->get(
                        sub {
                            my ( $body, $hdr ) = @_;
                            return if ( !$body || $hdr->{Status} !~ /^2/ );

                            my $decode_body = decode ("utf8", $body);
                            my @titles = $decode_body =~ m{<!\[CDATA\[(.*?)\]\]>}gsm;
                            my @urls = $decode_body =~ m{<link>(.*?)</link>}gsm;
                            my @times = $decode_body =~ m{<pubDate>(.*?) \+0900</pubDate>}gsm;
                            p @urls;
                            p @titles;

                            my @new_titles;
                            my @new_urls;
                            my $cnt = 0;

                            if ( $robot->brain->{data}{old_titles} ) {
                                for my $title (@titles) {
                                    unless ( $title eq $robot->brain->{data}{old_titles}->[$cnt] ) {
                                        push @new_titles, $title;
                                    }
                                $cnt++;
                                }
                                for my $url (@urls) {
                                    unless ( $url eq $robot->brain->{data}{old_urls}->[$cnt] ) {
                                        push @new_urls, $url;
                                    }
                                $cnt++;
                                }
                            }

                            else {
                                $robot->brain->{data}{old_titles} = \@titles;
                                $robot->brain->{data}{old_times} = \@times;
                                $robot->brain->{data}{old_urls} = \@urls;
                            }

                            if ( $new_titles[0] eq $robot->brain->{data}{olde_titles}->[0]) {
                            }
                            else {
                                $msg->send('카페(perlstudy)에 새로운 질문(댓글)이 올라왔습니다');
                                $msg->send('-> ' . "$new_titles[0]");
                                $msg->send('Link: ' . "$new_urls[1]");
                                $robot->brain->{data}{old_titles} = \@titles;
                                $robot->brain->{data}{old_urls} = \@urls;
                            }
                        }
                    );
                }
            );
            $cron->start;
            $flag = 'on';
        }
    );

    $robot->hear(
            qr/^perlstudy:? (?:off|finsh) *$/i,

            sub {
                my $msg = shift;
                $cron->stop;
                $msg->send('It has been stoped monitoring [cafe-perlstudy]...');
                $flag = 'off';
            }
    );

    $robot->hear(
            qr/^perlstudy:? status *$/i,    

            sub {
                my $msg = shift;
                $msg->send("perlstudy status is [$flag] ...");
            }
    );
}
1;

=pod

=head1 Name 

    Hubot::Scripts::perlstudy
 
=head1 SYNOPSIS

    naver perl cafe (new issue) monitoring.
    perlstudy on - naver cafe(perlstudy) to start monitoring.
    perlstudy off|finsh - naver cafe(perlstudy) to stop monitoring.
    perlstudy status - naver cafe(perlstudy) status.
 
=head1 AUTHOR

    YunChang Kang <codenewb@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Yunchang Kang.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself
 
=cut
