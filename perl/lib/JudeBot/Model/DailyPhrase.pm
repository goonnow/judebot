package JudeBot::Model::DailyPhrase;

use strict;
use warnings;
use LWP::Curl;
use Moose;
use Date::Format;
use JSON::PP;
use FindBin;
use File::Read;

has 'api' => ( is=>'rw',default => 'http://www.ihbristol.com/english-phrases' );
has 'article_url' => ( is=>'ro', default => 'http://www.ihbristol.com/english-phrases/example/' );
has 'datapath' => ( is=>'rw', default => sub {
    my $filename = 'phrase-of-today.json';

    if( $ENV{JudeBotShare} ) {
        return "$ENV{JudeBotShare}/$filename";
    }
    return "/var/share/$filename";
});


sub get_data {
    my $self = shift;
    my $data = $self->_parse();
    my $encoded_json = encode_json $data;

    $self->_update_json($encoded_json);

    return $data;
}

sub data {
    my $self = shift;
    return read_file($self->datapath);
}

sub _parse {
    my $self = shift;

    my $lwpcurl = LWP::Curl->new();
    my $content = $lwpcurl->get($self->api);
    my $obj;

    $content =~ m/class\="colorb\">(.+)<\/p>/;
    $obj->{phrase} = $1;

    $content =~ m/<em>(.+)<\/em>/;
    $obj->{desc} = $1;

    $obj->{timestamp} = time;

    $obj->{url} = $self->article_url . time2str('%Y-%m-%d', time);

    return $obj;
}

sub _update_json {
    my $self = shift;
    my $data = shift;
    open (DATAFILE, '>'.$self->datapath) or die "Can't open data";
    print DATAFILE $data;
    close(DATAFILE);
}

1;

