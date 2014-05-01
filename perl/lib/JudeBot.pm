package JudeBot;
use Mojo::Base 'Mojolicious';
use JudeBot::Model::DailyPhrase;

# This method will run once at server start
sub startup {
  my $self = shift;

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('controller-english#potd');


  $self->setup_routes();
  $self->make_attributes();
}

sub make_attributes {
    my ($self, $cfg) = @_;
    $self->attr( eng_model => sub { JudeBot::Model::DailyPhrase->new(); } );
}

sub setup_routes {
    my ($self) = @_;
    my $routes = $self->routes;
}

1;
