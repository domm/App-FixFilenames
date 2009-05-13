package App::FixFilenames::Command::SetID3;

use strict;
use warnings;
use 5.010;

use App::FixFilenames -command;
use base 'App::FixFilenames';
use MP3::Tag;

sub opt_spec {
    return (
        [ 'artist=s',   'Artist name' ],
        [ 'album=s',   'Album name' ],
    );
}

sub run {
    my ( $self, $opt, $args ) = @_;

    $self->findfiles;
    
    my $artist = $opt->{artist};
    my $album = $opt->{album};

    foreach my $path ( @{ $self->files } ) {
        say "processing $path" if $self->verbose > 1;

        my $tags = MP3::Tag->new($path);
        $tags->album_set($album) if $album;
        $tags->artist_set($artist) if $artist;
        $tags->update_tags;
        $self->{count}++;
    }

    $self->report;
}

1;
__END__

=head1 NAME

App::FixFilenames::Command::SetID3 - set id3 tags

=head1 SYNOPSIS

  fixfilenames.pl setid3 --artist "The Streets"

=head1 DESCRIPTION

Add the same ID3-Tag to several files. Currently supports C<artist> and C<album>

=head1 AUTHOR

Thomas Klausner E<lt>domm {at} cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
