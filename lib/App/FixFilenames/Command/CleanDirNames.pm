package App::FixFilenames::Command::CleanDirNames;

use strict;
use warnings;
use 5.010;

use App::FixFilenames -command;
use base 'App::FixFilenames';
use File::Spec::Functions;
use Data::Dumper;

sub run {
    my ( $self, $opt, $args ) = @_;
    my $gopts = $self->app->global_options;

    my @dirs = File::Find::Rule->directory->in( $gopts->{dir} );
    foreach my $dir (
        map { $_->[0]} 
        sort { $b->[1] <=> $a->[1]}
        map { [$_, length($_)]} @dirs) {
        next if $dir eq '.';
        my @dir = split('/',$dir);
        my $tail = pop(@dir);
        next if $tail =~ /^[a-z\d\-_]+$/;
        my $safe = $self->_safe_filename($tail);
        $self->rename_file($dir,undef,join('/',@dir,$safe));
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
