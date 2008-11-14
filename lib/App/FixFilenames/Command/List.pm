package App::FixFilenames::Command::List;

use strict;
use warnings;
use 5.010;

use App::FixFilenames -command;
use base 'App::FixFilenames';

sub run {
    my ( $self, $opt, $args ) = @_;

    $self->findfiles;
    print join( "\n", @{ $self->files } ) . "\n";

}

1;
__END__

=head1 NAME

App::FixFilenames::Command::List - just list files

=head1 SYNOPSIS

Just list the stuff that's found

=head1 DESCRIPTION

App::FixFilenames is

=head1 AUTHOR

Thomas Klausner E<lt>domm {at} cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
