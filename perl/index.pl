#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/lib" }

# Start command line interface for application
require Mojolicious::Commands;
warn "Current folder : $FindBin::Bin";
Mojolicious::Commands->start_app('JudeBot');
