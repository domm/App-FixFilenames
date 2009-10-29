package App::FixFilenames::Command::CheapMP3;

use strict;
use warnings;
use 5.010;

use App::FixFilenames -command;
use base 'App::FixFilenames';
use MP3::Info ();
use File::Spec::Functions;
use Data::Dumper;

sub opt_spec {
    my $self = shift;

    return ( [
            'player=s',
            'mount point of gogear disk',
        ],
        [ 'type=s@', 'file type (default mp3)', { default => ['mp3'] } ],
    );
}

sub run {
    my ( $self, $opt, $args ) = @_;

    $self->findfiles($opt);

    my @to_copy;

    foreach my $path ( @{ $self->files } ) {
        push(@to_copy,$path); 
    }
    
    foreach my $path (sort @to_copy) {
        say "processing $path" if $self->verbose > 1;
        my $info = MP3::Info->new($path);
        my $album = $self->_safe_filename( $info->album // 'unkown' );
        my $artist = $self->_safe_filename( $info->artist // 'unkown' );
        my ( $dir, $file, $ext ) = $self->splitfilepath($path);
        
        $self->copy_file( $path,
            catdir($opt->{player},$artist,$album), $file.'.'.$ext );
    }

    $self->report;
}

1;
__END__

=head1 NAME

App::FixFilenames::Command::CheapMP3 - copy files in the correct order to a cheap mp3 player

=head1 SYNOPSIS

  fixfilenames.pl cheapmp3

=head1 DESCRIPTION

=head1 AUTHOR

Thomas Klausner E<lt>domm {at} cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
