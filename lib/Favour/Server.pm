package Favour::Server;
use HTTP::Engine;
use Favour::Server::Static;
use Favour::Server::JSORB;

use Moose::Autobox;
use MooseX::Types::Path::Class qw(Dir);
use Moose;

use 5.010;

use namespace::clean -except => 'meta';

has 'app' => (
    is       => 'ro',
    isa      => 'Favour',
    required => 1,
    weak_ref => 1,
);

has 'static_base' => (
    is       => 'ro',
    isa      => Dir,
    required => 1,
    coerce   => 1,
);

has 'static' => (
    is         => 'ro',
    isa        => 'Favour::Server::Static',
    lazy_build => 1,
);

has 'jsorb' => (
    is      => 'ro',
    isa     => 'Favour::Server::JSORB',
    default => sub { Favour::Server::JSORB->new },
);

has 'engine' => (
    is         => 'ro',
    isa        => 'HTTP::Engine',
    lazy_build => 1,
);

sub _build_engine {
    my $self = shift;
    return HTTP::Engine->new(
        interface => {
            module => 'ServerSimple',
            args   => {
                host => 'localhost',
                port => 3000,
            },
            request_handler => sub {
                $self->_handle_request(@_);
            }
        },
    );
}

sub _build_static {
    my $self = shift;
    return Favour::Server::Static->new(
        base => $self->static_base,
    );
}

sub _handle_request {
    my ($self, $request) = @_;
    my $path = $request->uri->canonical->path;

    Favour::Server::Request->meta->rebless_instance($request);

    my $context = Favour::Server::Context->new(
        app     => $self->app,
        request => $request,
    );

    my $response;
    given($path){
        when(m{^/$}){
            $response = $self->static->resource('index.html')->serve($context);
        }
        when(m{^/static/(.+)$}){
            $response = $self->static->resource($1)->serve($context);
        }
        when(m{^/jsorb/?$}){
            $response = $self->jsorb->serve($context, $1);
        }
    }
    return $response || die 'no response';
}

sub start {
    my $self = shift;
    return $self->engine->run;
}

1;
