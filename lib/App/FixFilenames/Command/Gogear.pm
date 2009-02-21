package App::FixFilenames::Command::Gogear;

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
            'gogear=s',
            'mount point of gogear disk',
            { default => '/mnt/gogear' }
        ],
        [ 'type=s@', 'file type (default mp3)', { default => ['mp3'] } ],
    );
}

sub run {
    my ( $self, $opt, $args ) = @_;

    $self->findfiles($opt);

    foreach my $path ( @{ $self->files } ) {
        say "processing $path" if $self->verbose > 1;
        my ( $dir, $file, $ext ) = $self->splitfilepath($path);

        my $info = MP3::Info->new($path);
        my $album = $self->_safe_filename( $info->album // 'unkown' );

        $file = $album . '_' . $file . '.' . $ext;
        $self->copy_file( $path,
            catdir( $opt->{gogear}, qw(_system media audio) ), $file );
    }

    $self->report;
}

1;
__END__

=head1 NAME

App::FixFilenames::Command::Gogear - copy & rename files to a gogear mp3 player

=head1 SYNOPSIS

  fixfilenames.pl gogear

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
