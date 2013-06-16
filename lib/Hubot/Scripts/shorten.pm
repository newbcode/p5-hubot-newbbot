package Hubot::Scripts::shorten;
use strict;
use warnings;

use DBI;
use URI;
use URI::QueryParam;
use HTTP::Request;
use LWP::UserAgent;
use JSON::XS;
use Encode 'decode';
use Data::Printer;
use AnyEvent::DateTime::Cron;

my $dbfile = 'shorten';
my $dsn = "dbi::mysql::dbname=$dbfile";
my $user = "";
my $password = "";
my $dbh;
my $msg;
my @row;

sub load {
    my ( $class, $robot ) = @_;

    $robot->hear(
        qr/(https?:\/\/\S+)/i,
        sub {
            $msg   = shift;
            my $sender = $msg->message->user->{name};
            return if $sender eq 'hubot';

            my $bitly = $msg->match->[0];
            if (   length $bitly > 50
                && $ENV{HUBOT_BITLY_USERNAME}
                && $ENV{HUBOT_BITLY_API_KEY} )
            {
                my $uri = URI->new("http://api.bitly.com/v3/shorten");
                $uri->query_form_hash(
                    login   => $ENV{HUBOT_BITLY_USERNAME},
                    apiKey  => $ENV{HUBOT_BITLY_API_KEY},
                    longUrl => $bitly,
                    format  => 'json'
                );
                my $ua  = LWP::UserAgent->new;
                my $req = HTTP::Request->new( 'GET' => $uri );
                my $res = $ua->request($req);
                return unless $res->is_success;
                my $data = decode_json( $res->content );
                $bitly = $data->{data}{url};
            }

            $msg->http( $msg->match->[0] )->header( "User-Agent",
                "Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20100101 Firefox/10.0.7 Iceweasel/10.0.7"
              )->get(
                sub {
                    my ( $body, $hdr ) = @_;
                    return if ( !$body || !$hdr->{Status} =~ /^2/ );

                    ## content-type
                    my @ct = split( /\s*,\s*/, $hdr->{'content-type'} );
                    if ( grep { /^image\/.+$/i } @ct || grep { !/text/i } @ct )
                    {
                        return $msg->send("[$ct[0]] - $bitly");
                    }

                    ### charset
                    ### <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
                    ### [FILTER] - <script type="text/javascript" src="http://news.chosun.com/dhtm/js/gnb_news_2011.js" charset="euc-kr"></script>
                    $body =~ s{\r\n}{\n}g;
                    my @charset_lines =
                      grep { $_ !~ /script/ } grep { /charset/ } split /\n/,
                      $body;
                    my $charset;
                    if ( "@{[ @charset_lines ]}" =~
                        /charset=(?:'([^']+?)'|"([^"]+?)"|([a-zA-Z0-9_-]+)\b)/ )
                    {
                        $charset = lc( $1 || $2 || $3 );
                    }

                    unless ($charset) {
                        for my $ct (@ct) {
                            if ( $ct =~ m/charset\s*=\s*(.*)$/i ) {
                                $charset = $1;
                            }
                            else {
                                $charset = 'utf-8';
                            }
                        }
                    }

                    $charset = 'euckr' if $charset =~ m/ksc5601/i;
                    eval { $body = decode( $charset, $body ) };
                    if ($@) {
                        return $msg->send("[$@] - $bitly");
                    }

                    my ($title) = $body =~ m/<title>(.*?)<\/title>/is;
                    $title = 'no title' unless $title;
                    $title =~ s/\n//g;
                    $title =~ s/(^\s+|\s+$)//g;
                    $msg->send("[$title] - $bitly");

                    #
                    # dbh 객체를 연결할때 utf8로 접속해야 하며 set names utf8로 설정해주어야 한다.
                    #
                    my $dsn = "dbi:mysql:dbname=$dbfile";
                    my $dbh = DBI->connect($dsn, $user, $password, {
                    PrintError       => 0,
                    RaiseError       => 1,
                    AutoCommit       => 1,
                    FetchHashKeyName => 'NAME_lc',
                    mysql_enable_utf8 => 1,
                    });
                    
                    $dbh->do("set names 'utf8';");
                    $dbh->do("INSERT INTO perlkr (nickname, title, url)
                            VALUES (?, ?, ?)", undef, $sender, $title, $bitly);
                }
              );
                my $dsn = "dbi:mysql:dbname=$dbfile";
                    my $dbh = DBI->connect($dsn, $user, $password, {
                    PrintError       => 0,
                    RaiseError       => 1,
                    AutoCommit       => 1,
                    FetchHashKeyName => 'NAME_lc',
                    mysql_enable_utf8 => 1,
                    });

                my $cron = AnyEvent::DateTime::Cron->new(time_zone => 'local');
                    $cron->add('38 12 * * *', sub {
                    my $t_time = `date`;
                    $msg->send($t_time);
                    my $sql = 'SELECT title, nickname FROM perlkr';
                    my $sth = $dbh->prepare($sql);
                    $sth->execute();
                    while ( @row = $sth->fetchrow_array) {
                        #$msg->send( "title: $row[0] nickname: $row[1]");
                        $msg->send( "title: $row[0] nickname: $row[1]");
                    }
                }); 
            $cron->start;
        }
    );
}

1;

=pod

=encoding utf-8

=head1 NAME

Hubot::Scripts::shorten

=head1 SYNOPSIS

    <url> - Shorten the URL using bit.ly

=head1 DESCRIPTION

Shorten URLs with bit.ly

=head1 CONFIGURATION

=over

=item HUBOT_BITLY_USERNAME

=item HUBOT_BITLY_API_KEY

=back

=head1 AUTHOR

Hyungsuk Hong <hshong@perl.kr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Hyungsuk Hong.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
