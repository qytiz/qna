$(document).on('turbolinks:load', function() {
  $('.vote').on('ajax:success', function(e) {
      $('.alert').html('');
      var vote;
      vote = e.detail[0];
      $('#' + vote.model+ '-' + vote.object_id+'-vote').find('.total-score').html(vote.total_score);
  }).on('ajax:error', function(e) {
      var errors;
      errors = e.detail[0];
      $('.alert').html('');
      $.each(errors, function(_field, array) {
          $.each(array, function(_index, value) {
              $('.alert').append('<p>' + value + '</p>');
          });
      });
  });
}); 
