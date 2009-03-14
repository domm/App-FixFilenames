package App::FixFilenames::Command::Ordered;

use strict;
use warnings;
use 5.010;

use App::FixFilenames -command;
use base 'App::FixFilenames';

use File::stat;

sub opt_spec {
    return (
        [ 'base=s',    'base name for new files' ],
        [ 'start=s',   'start counter' ],
    );
}

sub run {
    my ( $self, $opt, $args ) = @_;

    $self->findfiles;

    my %info;
    foreach my $path ( @{ $self->files } ) {
        my $stat = stat($path);
        $info{$path}=$stat->mtime;
    }
    
    my $format = $opt->{base} ? $opt->{base}.'_' : '';
    $format.="%0".length(scalar keys %info)."d";
    
    my $count = $opt->{start} // 1;
    foreach my $path ( sort { $info{$a} <=> $info{$b} } keys %info ) {
        say "processing $path $info{$path}" if $self->verbose >= 1;
        my ( $dir, $file, $ext ) = $self->splitfilepath($path);
        my $new = sprintf( $format, $count++ );
        $self->rename_file( $path, $dir, $new . '.' . $ext );
    }

    $self->report;
}

1;
__END__

=head1 NAME

App::FixFilenames::Command::Ordered - rename all files according to some order

=head1 SYNOPSIS

  fixfilenames.pl ordered

=head1 DESCRIPTION

Renames all files to a ordered sequence of file nums. Currently only sorts by mtime.

=head1 AUTHOR

Thomas Klausner E<lt>domm {at} cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
