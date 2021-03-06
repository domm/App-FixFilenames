package App::FixFilenames::Command::LowercaseExtension;

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
        my $new = join('.',$file,lc($ext));
        $self->rename_file( $path, $dir, $new );
    }
    
    $self->report;
}

1;
__END__

=head1 NAME

App::FixFilenames::Command::LowercaseExtension - well, lowercase the extension

=head1 SYNOPSIS

  fixfilenames.pl lowercaseextension

=head1 DESCRIPTION

Makes sure all extensions are in lower case

=head1 AUTHOR

Thomas Klausner E<lt>domm {at} cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
