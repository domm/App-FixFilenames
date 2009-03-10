package App::FixFilenames::Command::FindBad;

use strict;
use warnings;
use 5.010;

use App::FixFilenames -command;
use base 'App::FixFilenames';

sub run {
    my ( $self, $opt, $args ) = @_;
    my $gopts = $self->app->global_options;

    my @bad = File::Find::Rule->any(
        File::Find::Rule->name(qr/[^A-Za-z\d\/\-_\.]/),
        File::Find::Rule->name(qr/\..*\./),
    )->in( $gopts->{dir} );

    print join( "\n", @bad ) . "\n";

}

1;
__END__

=head1 NAME

App::FixFilenames::Command::FindBad - find filenames I don't like

=head1 SYNOPSIS

  fixfilenames.pl findbad

=head1 DESCRIPTION

Find files with filenames I don't like

=head1 AUTHOR

Thomas Klausner E<lt>domm {at} cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
