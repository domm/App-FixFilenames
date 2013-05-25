package App::FixFilenames::Command::FromID3;

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

    return ( 
        [ 'type=s@', 'file type (default mp3)', { default => ['mp3'] } ],
        [ 'force', 'rename files even if the already seem ok' ],
    );
}

sub run {
    my ( $self, $opt, $args ) = @_;

    $self->findfiles($opt);

    foreach my $path ( @{ $self->files } ) {
        say "processing $path" if $self->verbose > 1;
        my ( $dir, $file, $ext ) = $self->splitfilepath($path);

        next if $file =~ /^\d+_[\w\d_-]+$/ && !$opt->{force};

        my $info = MP3::Info->new($path);
        my $raw_title = $info->title;
        $raw_title=~s/^.*\///g;
        my $title;
        if (!$info->album) {
            if ($info->artist) {
                $title = join('_',$self->_safe_filename($info->artist),$self->_safe_filename($info->title));
            }
            else {
                $title = 'unkown_'.int(rand(1000));
            }
            $title.='.mp3';
        }
        else {
            $title = $self->_safe_filename( $raw_title );
            my $tracknum=$info->tracknum;
            if (!$tracknum && $file=~/^(\d+)/) {
                $tracknum = $1;
            }
            $tracknum ||=0;
            $tracknum=~s/\D+.*//;
            $title = sprintf("%02d_%s.mp3",$tracknum,$title);
        }

        $self->rename_file( $path, $dir, $title );
    }

    $self->report;
}

1;
__END__

=head1 NAME

App::FixFilenames::Command::FromID3 - rename an mp3 file from it's ID3 tags

=head1 SYNOPSIS

  fixfilenames.pl fromid3

=head1 DESCRIPTION

Generate filenames for mp3 files from ID3-Tags. Filename will be F<tracknum_title.mp3>

=head1 AUTHOR

Thomas Klausner E<lt>domm {at} cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
