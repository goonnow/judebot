use lib "$ENV{JudeBotPath}/perl/lib";
use JudeBot::Model::DailyPhrase;
use Date::Format;

my $model = JudeBot::Model::DailyPhrase->new;
$model->get_data();
