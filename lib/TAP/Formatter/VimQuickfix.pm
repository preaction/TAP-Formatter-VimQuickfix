package TAP::Formatter::VimQuickfix;

use strict;
use base 'TAP::Formatter::Base';
use TAP::Formatter::VimQuickfix::Session;

our $VERSION = 0.001;

=head1 NAME

TAP::Formatter::VimQuickfix -- Format TAP output into Vim's quickfix window

=head1 USAGE

 prove --formatter TAP::Formatter::VimQuickfix ...

 # In your .vimrc
 set makeprg=prove\ -v\ --formatter\ TAP::Formatter::VimQuickfix
 set shellpipe=\|\ tee      " Get rid of the 2>&1 which will mess up our output

=head1 DESCRIPTION

This TAP::Formatter allows you to view failed tests in Vim's quickfix window. 
Then you can quickly move between failed tests.

Note: This formatter relies on the YAML metadata added in TAP version 13. If 
you are using L<Test::More> for your tests, you can enable the YAML metadata by
installing L<Test::More::Diagnostic> and use-ing it right below Test::More, like
so:

 use Test::More;
 use Test::More::Diagnostic;

Any other Test::* module that supports YAML metadata will support this formatter.

=head1 SEE ALSO

=head2 Vim documentation

=over 4

=item :help :make

=item :help :cnext

=back

=head1 METHODS

=head2 open_test

Called when a new test is opened. Starts a new formatter session.

=cut

sub open_test {
    my ( $self, $test, $parser ) = @_;

    # Start a new test session
    my $session = TAP::Formatter::VimQuickfix::Session->new( {
        name        => $test,
        formatter   => $self,
        parser      => $parser
    } );

    return $session;
}

# Do not show the default summary
sub summary { }
# Do not show the running count of tests run
sub _should_show_count { 0 }

# TODO: Do not show the verbose comments

=head1 LICENSE & COPYRIGHT

Copyright 2010 Doug Bell, all rights reserved.

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

1;
