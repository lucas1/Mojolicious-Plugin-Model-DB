package Mojolicious::Plugin::Model::DB;
use Mojo::Base 'Mojolicious::Plugin::Model';
use Moo;

our $VERSION = '0.01';

after register => sub {
    my ($plugin, $app, $conf) = @_;
    
    $app->helper(
        db => sub {
            my ($self, $name) = @_;
            $name //= $conf->{default};
            
            my $model;
            return $model if $model = $plugin->{models}{$name};
            
            my $class = _load_class_for_name($plugin, $app, $conf, $name)
                or return undef;
            
            my $params = $conf->{params}{$name};
            $model = $class->new(ref $params eq 'HASH' ? %$params : (), app => $app);
            $plugin->{models}{$name} = $model;
            return $model;
        }
    );    
};

sub _load_class_for_name {
    my ($plugin, $app, $conf, $name) = @_;
    return $plugin->{classes_loaded}{$name} if $plugin->{classes_loaded}{$name};
    
    my $namespace = $conf->{namespace}    // 'DB';
    my $ns        = $conf->{namespaces}   // [Mojolicious::Plugin::Model::camelize($app->moniker) . '::Model'];
    my $base      = $conf->{base_classes} // [qw(MojoX::Model)];
    
    $name = Mojolicious::Plugin::Model::camelize($name) if $name =~ /^[a-z]/;
    
    for my $class ( map "${_}::$namespace\::$name", @$ns ) {
        next unless Mojolicious::Plugin::Model::_load_class($class);
      
        unless ( Mojolicious::Plugin::Model::any { $class->isa($_) } @$base ) {
            $app->log->debug(qq[Class "$class" is not a model db]);
            next;
        }
        $plugin->{classes_loaded}{$name} = $class;
        return $class;
    }
    $app->log->debug(qq[Model db "$name" does not exist]);
    return undef;    
}

1;
