$(function() {
  $('.wmd-output').each(function(i) {
    var converter = new Markdown.Converter();
    var content = $(this).html();
    $(this).html(converter.makeHtml(content));
  });
});

$(document).ready(function () {
  $('#new_post').validate({
    rules: {
      post_title: {
        required: true
      },
      post_body: {
        required: true
      }
    }
  });
});
