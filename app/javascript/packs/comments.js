$(document).on('turbolinks:load', function(){
  $('.add-comment').on('click', function(e){
      e.preventDefault();
      $(this).hide();
      var commentable = $(this).data('commentable');
      $('form.new-comment-' + commentable).removeClass('hidden');
  });
});