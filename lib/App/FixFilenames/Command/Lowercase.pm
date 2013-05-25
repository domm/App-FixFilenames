package App::FixFilenames::Command::Lowercase;

use strict;
use warnings;
use 5.010;

use App::FixFilenames -command;
use base 'App::FixFilenames';

sub run {
    my ( $self, $opt, $args ) = @_;

    $self->findfiles();
    
    foreach my $path ( @{ $self->files } ) {
        say "processing $path" if $self->verbose >= 1;
        my ( $dir, $file, $ext ) = $self->splitfilepath($path);
        my $new = join('.',lc($file),lc($ext));
        $self->rename_file( $path, $dir, $new );
    }
    
    $self->report;
}

1;
__END__

=head1 NAME

App::FixFilenames::Command::Lowercase - well, lowercase the filename

=head1 SYNOPSIS

  fixfilenames.pl lowercase

=head1 DESCRIPTION

Makes sure the filename is in lower case

=head1 AUTHOR

Thomas Klausner E<lt>domm {at} cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
