use Test::More;
use Time::Mock;
use JudeBot::Model::DailyPhrase;
use FindBin;
use File::Temp qw/ tempfile /;
use File::Read;
use JSON::PP;

Time::Mock->set("2014-02-02 00:59");

my $model = JudeBot::Model::DailyPhrase->new;

$model->api("file:///$FindBin::Bin/data/phrase-of-the-day.html");

subtest 'parse' => sub {
    my $obj = $model->_parse();

    is( $obj->{phrase}, 'Suit yourself', 'Phrase Ok' );
    is( $obj->{desc}, 'We use this expression to reply to someone who has made a decision we don\'t agree with or approve of.', 'Desc Ok!');
    like( $obj->{url}, qr/2014-02-02/, 'URL Ok!' );
};

subtest 'fetch_data' => sub {
    my( $fh, $filename ) = tempfile();

    # Mock datapath
    $model->datapath($filename);

    my $data = $model->get_data();
    my $saved_data = decode_json read_file($filename);
    is_deeply( $data, $saved_data, 'Save data to file' );
};

subtest '_update_feed' => sub {
    my( $fh, $filename ) = tempfile();

    # Mock feedpath
    $model->feedpath($filename);

    my $expect = read_file("$FindBin::Bin/data/phrase-of-the-day.atom");

    my $data = [ { title => 'Dog' }, { title => 'Cat' } ];
    $model->_update_feed($data);

    is_deeply( read_file($filename), $expect, 'Feed is written' );
    ok(0);
};
done_testing();

