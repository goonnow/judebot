package JudeBot::Model::FileDB;

use strict;
use warnings;
use Moose;
use File::Read;
use constant SEPERATOR => '#';
use constant EXT => '.fdb';

has 'db_name' => ( is => 'rw' ); # Aka Filename

sub insert {
    my $self = shift;
    my $obj = shift;

    my $row = $self->_build_row($obj);

    $self->_write( $row );

    return 1;
}

sub remove_row {
}

sub get_row {
    my $self = shift;
    my $row = shift;
    my $data = read_file( $self->db_file );

    my @lines = split( /\n/, $data );

    my $line = $lines[$row];
    my @cols = split( SEPERATOR, $line );
    my $obj;
    foreach (@cols) {
        my ( $key, $value ) = split( ':', $_ );
        $obj->{$key} = $value;
    }
    return $obj;
}

sub _build_row {
    my $self = shift;
    my $obj = shift;

    my @cols;
    foreach my $k ( keys %{$obj} ) {
        my $col = $k.':'.$obj->{$k};
        push @cols, $col;
    }

    my $row = join( SEPERATOR, @cols );
    return $row;
}

sub _write {
    my $self = shift;
    my $data = shift;
    open (DATAFILE, '>>'.$self->db_file) or die "Can't open data";
    print DATAFILE $data;
    close(DATAFILE);
}

sub db_file {
    my $self = shift;
    return $self->db_name.EXT;
}

1;
