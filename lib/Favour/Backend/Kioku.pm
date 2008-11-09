package Favour::Backend::Kioku;
use Moose;
use KiokuDB;

use MooseX::Types::Path::Class qw(Dir);

use namespace::clean -except => 'meta';

has storage => (
    is       => 'ro',
    isa      => Dir,
    required => 1,
    coerce   => 1,
);

has extra_options => (
    is         => 'ro',
    isa        => 'HashRef',
    default    => sub { +{} },
    auto_deref => 1,
);

has backend_class => (
    is       => 'ro',
    isa      => 'ClassName',
    required => 1,
    default  => sub {
        require KiokuDB::Backend::BDB;
        return 'KiokuDB::Backend::BDB';
    },
);

has db => (
    is         => 'ro',
    isa        => 'KiokuDB',
    lazy_build => 1,
    handles    => [qw(
        new_scope
        lookup
        store
        insert
        update
        search
        delete
        object_to_id
        objects_to_ids
        live_objects
        txn_do
    )],
);

sub _build_db {
    my $self = shift;

    my @extra = $self->extra_options;

    return KiokuDB->new(
        backend => $self->backend_class->new(
            manager => {
                home   => $self->storage,
                create => 1,
                @extra,
            },
            @extra,
        ),
        @extra,
    );
}

1;
