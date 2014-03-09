# Controller
package JudeBot::Controller::English;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dump qw(dump);


# Phare of today
sub potd {
    my ($self) = @_;

    my $model = $self->app->eng_model;

    $self->render(data => $model->data);
}

1;
