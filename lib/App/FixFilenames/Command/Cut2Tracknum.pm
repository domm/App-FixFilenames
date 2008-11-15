package App::FixFilenames::Command::Cut2Tracknum;

use strict;
use warnings;
use 5.010;

use App::FixFilenames -command;
use base 'App::FixFilenames';

sub run {
    my ( $self, $opt, $args ) = @_;

    $self->findfiles;

    foreach my $path ( @{ $self->files } ) {
        say "processing $path" if $self->verbose > 1;
        my ( $dir, $file, $ext ) = $self->splitfilepath($path);
        $file =~ s/\D//g;
        my $new = sprintf( "%02d", $file );
        $self->rename_file( $path, $dir, $new . '.' . $ext );
    }

    $self->report;
}

1;
__END__

=head1 NAME

App::FixFilenames::Command::Cut2Tracknum - remove everything before what looks like a tracknum

=head1 SYNOPSIS

  fixfilenames.pl cut2tracknum --type mp3

=head1 DESCRIPTION

Removes everything but the tracknum (or what looks like it) from the filename

i.e something like F<foo-3.mp3> is turned into C<03.mp3>.

I use this to convert filenames generated by audacity multifile export 
into something I can further process.

=head1 AUTHOR

Thomas Klausner E<lt>domm {at} cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut