# NAME
 
Mojolicious::Plugin::Model::DB - It is an extension of the module [Mojolicious::Plugin::Model](https://metacpan.org/pod/Mojolicious::Plugin::Model)
for Mojolicious applications

# SYNOPSIS

Model Users
 
    package MyApp::Model::DB::Person;
    use Mojo::Base 'MojoX::Model';
 
    sub save {
        my ($self, $foo) = @_;
        
        $mysql->db->insert(
            'foo',
            {
                foo => $foo
            }
        );
    }
 
    1;
    
Mojolicious::Lite application
 
    #!/usr/bin/env perl
    use Mojolicious::Lite;
 
    use lib 'lib';
 
    plugin 'Model::DB';
 
    any '/' => sub {
        my $c = shift;
 
        my $foo = $c->param('foo') || '';
        
        $c->db('person')->save($foo);
        
        $c->render(text => 'Save person foo');
    };
 
    app->start;
    
All available options

    #!/usr/bin/env perl
    use Mojolicious::Lite;
    
    plugin Model => {
        # Mojolicious::Plugin::Model::DB
        namespace => 'DataBase', # default is DB
    
        # Mojolicious::Plugin::Model
        namespaces   => ['MyApp::Model', 'MyApp::CLI::Model'],
        base_classes => ['MyApp::Model'],
        default      => 'MyApp::Model::Pg',
        params => {Pg => {uri => 'postgresql://user@/mydb'}}
    };
    
# DESCRIPTION
 
[Mojolicious::Plugin::Model::DB](https://metacpan.org/pod/Mojolicious::Plugin::Model::DB) It is an extension of the module Mojolicious::Plugin::Model, see more in [Mojolicious::Plugin::Model](https://metacpan.org/pod/Mojolicious::Plugin::Model)
for Mojolicious applications