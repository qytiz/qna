import consumer from "./consumer";

$(document).on('turbolinks:load', function () {
    const questionId = $('.question').data('id');
    
    let template = require('./templates/comments.hbs')
    consumer.subscriptions.create({channel: "CommentsChannel", question_id: questionId} , {
      connected() {
        // Called when the subscription is ready for use on the server
        console.log('Connected to comments')
      },
      received(data) {
        if (gon.user_id == data.comment.user_id) return;
        let commentsList = $(`.comments-${data.commentable_type}-${data.comment.commentable_id}`);
        commentsList.append(template(data));
      }
    });
});