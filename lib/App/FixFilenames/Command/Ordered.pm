package App::FixFilenames::Command::Ordered;

use strict;
use warnings;
use 5.010;

use App::FixFilenames -command;
use base 'App::FixFilenames';
use DateTime::Format::Strptime;
use Image::ExifTool;
use File::stat;

my $dateparser = DateTime::Format::Strptime->new(pattern=>'%Y:%m:%d %H:%M:%S');

sub opt_spec {
    return (
        [ 'base=s',    'base name for new files' ],
        [ 'start=s',   'start counter' ],
        [ 'padding=s',   'number of zeros to pad' ],
        [ 'exif',        'use exif date instead of file mtime'],
        [ 'filename',        'use filename instead of file mtime'],
        [ 'reverse',        'reverse order'],
    );
}

sub run {
    my ( $self, $opt, $args ) = @_;

    $self->findfiles;

    my %info;
    my $sortmode = 'numeric';
    if ($opt->{exif}) {
        foreach my $path ( @{ $self->files } ) {
            my $exif = Image::ExifTool->new;
            $exif->ExtractInfo($path);
            my $created = $dateparser->parse_datetime($exif->GetValue('CreateDate'))->epoch;
            $info{$path}=$created;
            utime($created,$created,$path);
        }
    }
    elsif ($opt->{filename}) {
        foreach my $path ( @{ $self->files } ) {
            $info{$path}=$path;
        }
        $sortmode = 'text';
    }
    else {
        foreach my $path ( @{ $self->files } ) {
            my $stat = stat($path);
            $info{$path}=$stat->mtime;
        }
    }
    
    my $format = $opt->{base} ? $opt->{base}.'_' : '';
    my $zeros = $opt->{padding} ||0;
    my $length = length(scalar keys %info);
    $zeros = $length if $zeros < $length;
    $format.="%0".$zeros."d";
    
    my $count = $opt->{start} // 1;
    my @sorted;
    if ($sortmode eq 'numeric') {
        @sorted = sort { $info{$a} <=> $info{$b} } keys %info
    }
    else {
        @sorted = sort { $info{$a} cmp $info{$b} } keys %info
    }

    if ($opt->{reverse}) {
        @sorted = reverse @sorted;
    }
    foreach my $path ( @sorted ) {
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
