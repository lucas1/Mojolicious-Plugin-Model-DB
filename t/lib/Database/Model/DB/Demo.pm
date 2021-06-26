package Database::Model::DB::Demo;
use Mojo::Base 'MojoX::Model';

sub find {
    my ($self, $id) = @_;

    return $self->sqlite->db->select(
        'demo',
        undef,
        {
            id => $id
        }
    )->hash;
}

1;
