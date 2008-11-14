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

__PACKAGE__->mk_accessors(qw(files dirs count));

sub global_opt_spec {
    return (
        [ 'dry-run',  'do not change anything' ],
        [ 'verbose+', 'well, be more verbose' ],
        [ 'dir=s',    'root directory to work from', { default => '.' } ],
        [ 'type=s@',  'file type (without the dot)', { default => ['*'] } ],
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
    if ( $gopts->{verbose} > 2 ) {
        say Dumper $self->files;
    }
}

sub rename_file {
    my ( $self, $oldpath, $dir, $new ) = @_;

    say "rename $oldpath to $new" if $self->verbose;

    if ( $self->dryrun ) {
        $self->{count}++;
        return $oldpath;
    }

    my $newpath = catfile( $dir, $new );
    rename( $oldpath, $newpath )
        || say STDERR "could not rename $oldpath to $newpath: $!";
    $self->{count}++;
    return $newpath;
}

sub splitfilepath {
    my ( $self, $path ) = @_;
    my ( undef, $dir, $file ) = splitpath($path);
    $file =~ /^(?<file>.*)\.(?<ext>\w+)$/;
    return ( $dir, $+{file}, $+{ext} );
}

sub report {
    my $self = shift;
    my $cnt  = $self->count;
    say "processed $cnt file" . ( $cnt != 1 ? 's' : '' );
}

sub verbose { return shift->app->global_options->{'verbose'} }

sub dryrun { return shift->app->global_options->{'dry_run'} }

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
