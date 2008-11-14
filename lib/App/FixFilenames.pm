package App::FixFilenames;

use strict;
use warnings;
use 5.010;
use version; our $VERSION = version->new('0.01');

use App::Cmd::Setup -app;
use base 'Class::Accessor::Fast';
use File::Find::Rule;
use File::Spec::Functions qw(:ALL);
use Data::Dumper;

__PACKAGE__->mk_accessors(qw(files dirs));

sub global_opt_spec {
    return (
        [ 'dry-run',  'do not change anything' ],
        [ 'verbose+', 'well, be more verbose' ],
        [ 'dir=s',    'root directory to work from', { default => '.' } ],
        [ 'type=s@',  'file type (without the dot)' ],
        [ 'recurse!', 'descend into subdirs',        { default => 1 } ],
    );
}

sub findfiles {
    my $self  = shift;
    my $gopts = $self->app->global_options;

    $self->files( [
            File::Find::Rule->file->name(
                map { '*.' . $_ } @{ $gopts->{type} }
                )->in( $gopts->{dir} )
        ]
    );
    if ($gopts->{verbose} > 1) {
        say Dumper $self->files;
    }
}

1;
__END__

=head1 NAME

App::FixFilenames -

=head1 SYNOPSIS

  use App::FixFilenames;

=head1 DESCRIPTION

App::FixFilenames is

=head1 AUTHOR

Thomas Klausner E<lt>domm {at} cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
