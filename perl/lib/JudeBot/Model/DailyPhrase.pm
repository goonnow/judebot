package JudeBot::Model::DailyPhrase;

use strict;
use warnings;
use LWP::Curl;
use Moose;
use Date::Format;
use JSON::PP;
use File::Read 'err_mode=quiet';
use Mojo::Template;
use Find::Lib '../lib';
use XML::Hash::LX;

has 'api' => ( is=>'rw',default => 'http://www.ihbristol.com/english-phrases' );
has 'article_url' => ( is=>'ro', default => 'http://www.ihbristol.com/english-phrases/example/' );

has 'assest_path' => ( is=>'rw', default => sub {
    my $filename = 'phrase-of-today';

    if( $ENV{JudeBotShare} ) {
        return "$ENV{JudeBotShare}/$filename";
    }
    return "/var/share/$filename";
});

sub file_path {
    my $self = shift;
    my $ext = shift;
    return $self->assest_path . ".$ext";
}

sub get_data {
    my $self = shift;
    my $data = $self->_parse();
    my $encoded_json = encode_json $data;

    $self->_update_json($encoded_json);

    my $old_data = $self->_read_feed();
    my $combined_data = $self->_combine_data( $old_data, $data );
    $self->_update_feed( $combined_data );

    return $data;
}

sub data {
    my $self = shift;
    return read_file($self->file_path('json'));
}

sub _parse {
    my $self = shift;

    my $lwpcurl = LWP::Curl->new();
    my $content = $lwpcurl->get($self->api);
    my $obj;

    $content =~ m/class\="colorb\">(.+)<\/p>/;
    $obj->{title} = $1;

    $content =~ m/<em>(.+)<\/em>/;
    $obj->{description} = $1;

    $obj->{pubDate} = localtime;

    $obj->{link} = $self->article_url . time2str('%Y-%m-%d', time);

    return $obj;
}

sub _update_json {
    my $self = shift;
    my $data = shift;
    open (DATAFILE, '>'.$self->file_path('json')) or die "Can't open data";
    print DATAFILE $data;
    close(DATAFILE);
}

sub _combine_data {
    my $MAX_ITEM = 5;
    my $self = shift;
    my $old_data = shift;
    my $new_data = shift;

    # Check duplicate title
    if( !grep { $_->{title} eq $new_data->{title} } @{ $old_data } ){
        push @{$old_data}, $new_data;
    }

    my $length = scalar @{ $old_data };

    # Limit items only 5 items
    splice( @{ $old_data }, 0, $length - $MAX_ITEM );

    return $old_data ;
}

sub _update_feed {
    my $self = shift;
    my $data = shift;

    my $mt = Mojo::Template->new;
    my $tp_path = Find::Lib->catfile("..", "templates", "feed.mt");
    my $output = $mt->render_file($tp_path, $data);

    write_file( $self->file_path('atom'), $output );
}

sub _read_feed {
    my $self = shift;
    my $xml = read_file( $self->file_path('atom') ) || return [];

    my $res = xml2hash( $xml );

    return $res->{rss}->{channel}->{item};
}

sub write_file {
    my $path = shift;
    my $data = shift;

    open (DATAFILE, '>'.$path) or die "Can't open data";
    print DATAFILE $data;
    close(DATAFILE);
}

1;

