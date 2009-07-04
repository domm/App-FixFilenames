package App::FixFilenames::Command::MkdirDate;

use strict;
use warnings;
use 5.010;

use App::FixFilenames -command;
use base 'App::FixFilenames';
use MP3::Info ();
use File::Spec::Functions;
use Data::Dumper;
use DateTime;

sub run {
    my ( $self, $opt, $args ) = @_;

    $self->findfiles($opt);

    foreach my $path ( @{ $self->files } ) {
        say "processing $path" if $self->verbose > 1;
        my ($mtime) = (stat($path))[9];
        my $dt = DateTime->from_epoch(epoch=>$mtime);
        my ( $dir, $file, $ext ) = $self->splitfilepath($path);
        my $datedir = $dt->ymd('');
        say "$datedir";
        unless (-d $datedir) {
            mkdir($datedir);
        }

        $self->move_file( $path, $datedir,$file);
    }

    $self->report;
}

1;
__END__

=head1 NAME

App::FixFilenames::Command::MkdirDate - mkdirs for each day, move files into dirs

=head1 SYNOPSIS

  fixfilenames.pl mkdirdate

=head1 DESCRIPTION

Goes through all files in the dir, makes a directory for each day, and 
moves all files created on that day into this dirs.

=head1 AUTHOR

Thomas Klausner E<lt>domm {at} cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
