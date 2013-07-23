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
                    $msg->http("http://cafe.naver.com/MyCafeIntro.nhn?clubid=18062050")->get(
                        sub {
                            my ( $body, $hdr ) = @_;
                            return if ( !$body || $hdr->{Status} !~ /^2/ );

                            my $decode_body = decode ("euc-kr", $body);

                            my @titles = $decode_body =~ m{<a href="/ArticleRead.nhn\?clubid=18062050&articleid=\w+&referrerAllArticles=true" class="m-tcol-c" title="(.*?)">}gsm;
                            my @urls = $decode_body =~ m{<a href="/ArticleRead.nhn\?clubid=18062050&articleid=(\w+)&referrerAllArticles=true" class="m-tcol-c" title=".*?">}gsm;
                            my @times = $decode_body =~ m{<\!-- 전체 목록 보기에서 질문 답변 게시판의 게시물인 경우 앞에 Q\.를 붙인다 -->.*?<td class="m-tcol-c">(.*?)</td>}gsm;
                            my @quests = $decode_body =~ m{<\!-- 전체 목록 보기에서 질문 답변 게시판의 게시물인 경우 앞에 Q\.를 붙인다 -->.*?<div class="ellipsis m-tcol-c">(.*?)</div>}gsm;
                            my @strongs = $decode_body =~ m{<\!-- 전체 목록 보기에서 질문 답변 게시판의 게시물인 경우 앞에 Q\.를 붙인다 -->.*?<strong>(.*?)</strong>}gsm;

                            if ( $robot->brain->{data}{old_titles} ) {
                                unless( $titles[0] eq $robot->brain->{data}{old_titles}->[0]) {
                                    $msg->send('카페(perlstudy)에 새로운 질문(댓글)이 올라왔습니다');
                                    $msg->send("제목:[$titles[0]]"." 등록자:[$quests[0]]"." 등록시간:[$times[0]]" );
                                    $msg->send("바로가기->http://cafe.naver.com/perlstudy/$urls[0]");
                                    $robot->brain->{data}{old_titles} = \@titles;
                                }
                            }

                            else {
                                $robot->brain->{data}{old_titles} = \@titles;
                                $robot->brain->{data}{old_urls} = \@urls;
                                $robot->brain->{data}{old_times} = \@times;
                                $robot->brain->{data}{old_quests} = \@quests;
                                $robot->brain->{data}{old_strongs} = \@strongs;
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
