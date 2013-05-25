package App::FixFilenames::Command::TVSeries;

use strict;
use warnings;
use 5.010;

use App::FixFilenames -command;
use base 'App::FixFilenames';

sub opt_spec {
    return (
        [ 'base=s',    'base name for new files' ],
        [ 'season_regex=s',   'regex for season prefix (default /s/)' ],
        [ 'episode_regex=s',   'regex for episode prefix default /e/)' ],
        [ 'mixed', 'parse something like 201 into s01e01'],
    );
}

sub run {
    my ( $self, $opt, $args ) = @_;

    $self->findfiles;
    
    my $season = $opt->{season_regex} || 's';
    my $episode = $opt->{episode_regex} || 'e';
    my $regex = qr/$season(?<season>\d+).*$episode(?<episode>\d+)/i;

    foreach my $path ( @{ $self->files } ) {
        say "processing $path" if $self->verbose > 1;
        my ( $dir, $file, $ext ) = $self->splitfilepath($path);

        my %match;

        if ($opt->{mixed}) {
            $file=~/(?<season>\d)(?<episode>\d\d)/;
            %match = %+;
        }
        else {
            $file=~/$regex/;
            %match = %+;
        }
        die "Cannot find season or episode in $file" unless $match{season} && $match{episode};
        my $new = $opt->{base} ? $opt->{base}.'_' : '';
        $new.= sprintf( "s%02de%02d", $match{season},$match{episode} );
        $self->rename_file( $path, $dir, $new . '.' . $ext );
    }

    $self->report;
}

1;
__END__

=head1 NAME

App::FixFilenames::Command::TVSeries - nice season and episode info

=head1 SYNOPSIS

  fixfilenames.pl tvseries --type avi --base dexter

=head1 DESCRIPTION

Renames files to something like 'dexter_s02e11.avi'. Assumes that you 
have filenames using some crap season/episode encodings (like you 
often get from bittorrent etc). 

Looks for something like 'SNNENN' in the old filename and uses this info to make a nice new filename. If you have some truly strange files, you can use C<--season_regex> and C<--episode_regex>, eg:

  fixfilenames.pl tvseries --dir hustle --type avi --base hustle
                           --season_regex season --episode_regex ep

..to turn something like F<HUSTLE.season1.ep5.avi> into F<hustle_s01e05.avi>

=head1 AUTHOR

Thomas Klausner E<lt>domm {at} cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
