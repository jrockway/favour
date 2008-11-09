package Favour::Server::JSORB;
use Favour::Controller::Color;
use JSORB;
use JSORB::Namespace;
use JSORB::Interface;
use JSORB::Method;
use JSORB::Dispatcher::Path;
use JSORB::Dispatcher::Traits::WithInvocantFactory;
use JSON::RPC::Common::Marshal::HTTP;
use Moose;

has 'jsorb_namespace' => (
    is         => 'ro',
    isa        => 'JSORB::Namespace',
    lazy_build => 1,
);

sub _build_jsorb_namespace {
    my $self = shift;
    return JSORB::Namespace->new(
        name     => 'Favour',
        elements => [
            JSORB::Namespace->new(
                name     => 'Controller',
                elements => [
                    JSORB::Interface->new(
                        name       => 'Color',
                        procedures => [
                            JSORB::Method->new(
                                name => 'add_color_pair',
                                spec => [ 'Any' => 'Any' ],
                            ),
                        ],
                    ),
                ],
            ),
        ],
    );
}

sub serve {
    my ($self, $c) = @_;

    my $d = JSORB::Dispatcher::Path->new(
        namespace => $self->jsorb_namespace,
    );

    my $marshaler = JSON::RPC::Common::Marshal::HTTP->new;
    my $call = $marshaler->request_to_call($c->request);

    unshift @{$call->params}, Favour::Controller::Color->new( context => $c );

    my $result = $d->handler(
        $call,
        $call->params_list,
    );

    my $response = $c->make_response;
    $marshaler->write_result_to_response($result, $response);
    return $response;
}

1;
