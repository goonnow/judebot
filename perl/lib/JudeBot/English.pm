# Controller
package JudeBot::English;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dump qw(dump);


# Phare of today
sub potd {
  my ($self) = @_;
  #my $c= shift;
   
  warn dump $self->app->model;
  my $name = $self->param('name');
  $self->render(json => {hello => $name});
}

1;
