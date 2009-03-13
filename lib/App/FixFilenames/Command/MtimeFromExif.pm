package App::FixFilenames::Command::MtimeFromExif;

use strict;
use warnings;
use 5.010;

use App::FixFilenames -command;
use base 'App::FixFilenames';

use File::stat;
use Time::localtime;
use Image::ExifTool qw(:Public);
use DateTime;
use DateTime::Format::Strptime;

sub run {
    my ( $self, $opt, $args ) = @_;

    $self->findfiles({ type => ['jpg']});
    my $strp=DateTime::Format::Strptime->new(pattern=>'%Y:%m:%d %H:%M:%S');

    my %info;
    foreach my $path ( @{ $self->files } ) {
        my $exif = Image::ExifTool->new;
        $exif->ExtractInfo($path);
        my $create_date=$exif->GetValue('CreateDate');
        my $dt = $strp->parse_datetime($create_date);
        my $created_epoch=$dt->epoch;
        my $mtime = stat($path)->mtime;
        next if $mtime == $created_epoch;
        say "$path: fix mtime from $mtime to $created_epoch";
        utime($created_epoch,$created_epoch,$path);
    }
    
    #$self->report;
}

1;
__END__

=head1 NAME

App::FixFilenames::Command::MtimeFromExif - set mtime from exif metadata

=head1 SYNOPSIS

  fixfilenames.pl mtimefromexif

=head1 DESCRIPTION

Sets the mtime of jpegs to the value stored in the exif tag CreateDate

=head1 AUTHOR

Thomas Klausner E<lt>domm {at} cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
