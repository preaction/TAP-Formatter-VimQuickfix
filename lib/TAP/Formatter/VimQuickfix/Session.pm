package TAP::Formatter::VimQuickfix::Session;

use strict;
use base 'TAP::Formatter::Session';
use Data::Dumper;

our $VERSION = 0.001;

=head1 NAME

TAP::Formatter::VimQuickfix::Session -- Handle a single test session

=cut

=head1 DESCRIPTION

This class is used by TAP::Formatter::VimQuickfix to handle a single test 
session. This seperation allows for multiple, simultaneous test sessions to
not show up incorrectly.

This class should not be used directly.

=head1 METHODS

=head2 close_test

Called when the test session is over. Outputs the collected results.

=cut

sub close_test { 
    my ( $self ) = @_;
    for my $data ( @{$self->{yamls}} ) {
        $self->formatter->_output(
            join( ":", $data->{file}, $data->{line}, $data->{description} )
            . "\n"
        );
    }
}

=head2 result

Called when a new result is ready to format. Collects the YAML metadata for 
failing tests.

=cut

sub result {
    my ( $self, $result ) = @_;

    if ( $result->is_test ) {
        if ( !$result->is_ok ) {
            $self->{grab_yaml} = 1;
            $self->{description} = join " ", $result->number, $result->description;
        }
        else {
            delete $self->{grab_yaml};
            delete $self->{description};
        }
    }
    elsif ( $result->is_yaml && $self->{grab_yaml} ) {
        push @{$self->{yamls}}, { description => delete $self->{description}, %{$result->data} };
    }
}

=head1 LICENSE & COPYRIGHT

Copyright 2010 Doug Bell, all rights reserved.

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

1;
