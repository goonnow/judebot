#!/usr/bin/perl

use strict;
use warnings;
use File::Basename 'dirname';
use File::Spec;

use lib join '/', File::Spec->splitdir(dirname(__FILE__)), 'lib';
use lib join '/', File::Spec->splitdir(dirname(__FILE__)), '..', 'lib';

# Start command line interface for application
require Mojolicious::Commands;

my $app = Mojolicious::Commands->start_app('JudeBot');

push @{$app->static->paths}, "$ENV{JudeBotShare}" if ( $ENV{JudeBotShare} );
