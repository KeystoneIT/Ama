package Ama::Controller::Comments;
use Mojo::Base 'Mojolicious::Controller';

sub create {
  my $self = shift;
  $self->stash(comment => {});
  $self->respond_to(
    json => {json => $self->stash('comment')},
    any => {},
  );
}

sub edit {
  my $self = shift;
  my $comment_id = $self->param('comment_id');
  $self->stash(comment => $self->comments->find($comment_id));
  $self->respond_to(
    json => {json => $self->stash('comments')},
    any => {},
  );
}

sub index {
  my $self = shift;
  my $question_id = $self->param('question_id');
  $self->stash(comments => $self->comments->all($question_id));
  $self->respond_to(
    json => {json => $self->stash('comments')},
    any => {},
  );
}

sub remove {
  my $self = shift;
  my $comment_id = $self->param('comment_id');
  $self->stash('comment' => $self->comments->remove($comment_id));
  $self->respond_to(
    json => {json => $self->stash('comment')},
    any => {},
  );
}

sub show {
  my $self = shift;
  my $comment_id = $self->param('comment_id');
  $self->stash(comment => $self->comments->find($comment_id));
  $self->respond_to(
    json => {json => $self->stash('comment')},
    any => {},
  );
}   

sub store {
  my $self = shift;

  my $validation = $self->_validation;
  return $self->respond_to(
    json => {json => {}},
    any => sub { $self->render(action => 'create', comment => {}) },
  ) if $validation->has_error;

  my $question_id = $self->param('question_id');
  my $comment = $self->param('comment');
  my $video_link = $self->param('video_link');
  $self->stash('comment' => $self->comments->add($question_id, $comment, $video_link));
  $self->respond_to(
    json => {json => $self->stash('comment')},
    any => sub { $self->redirect_to('questions')},
  );
}   

sub update {
  my $self = shift;
  my $validation = $self->_validation;
  return $self->respond_to(
    json => {json => {}},
    any => sub { $self->render(action => 'edit', comment => {}) },
  ) if $validation->has_error;

  my $comment_id = $self->param('comment_id');
  my $comment = $self->param('comment');
  my $r = $self->comments->save($comment_id, $comment);
  $self->stash('comment' => $r);
  $self->respond_to(
    json => {json => $self->stash('comment')},
    any => {},
  );
}   

sub _validation {
  my $self = shift;

  my $validation = $self->validation;
  $validation->required('question_id');
  $validation->required('comment');
  return $validation;
}

1;
