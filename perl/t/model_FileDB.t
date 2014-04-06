use strict;
use warnings;
use Test::More;
use JudeBot::Model::FileDB;
use File::Temp qw/ tempfile/;
use File::Read;
use FindBin;

my ($file, $tempdb) = tempfile();
my $model = JudeBot::Model::FileDB->new( 'db_name' => $tempdb );
subtest '_build_row' => sub {
    my $obj = {
        name    =>'foo',
        surname => 'bar'
    };

    my $row = $model->_build_row($obj);

    is( $row, 'name:foo#surname:bar');
};

subtest 'insert' => sub {
    my $obj = {
        name    =>'foo',
        surname => 'bar'
    };

    $model->insert( $obj );
    is( read_file($model->db_file), 'name:foo#surname:bar');
};

subtest 'get_row' => sub {
    my $model = JudeBot::Model::FileDB->new( 'db_name' => "$FindBin::Bin/data/test" );
    use Data::Dump qw(dump);

    my $obj =$model->get_row(1);
    my $exp = {
        name => 'king',
        surname => 'queen'
    };
    is_deeply( $obj, $exp );
};
done_testing();

