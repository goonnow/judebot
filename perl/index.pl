#!/usr/bin/perl

use strict;
use warnings;
use File::Basename 'dirname';
use File::Spec;

use lib join '/', File::Spec->splitdir(dirname(__FILE__)), 'lib';
use lib join '/', File::Spec->splitdir(dirname(__FILE__)), '..', 'lib';

warn File::Spec->splitdir(dirname(__FILE__));

# Start command line interface for application
require Mojolicious::Commands;
Mojolicious::Commands->start_app('JudeBot');
