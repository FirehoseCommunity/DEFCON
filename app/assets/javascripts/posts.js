$(function() {
  $('.wmd-output').each(function(i) {
    var converter = new Markdown.Converter();
    var content = $(this).html();
    $(this).html(converter.makeHtml(content));
  });
});

$(document).ready(function () {
    $('#new_post').validate();
});


<script>
  $(document).ready(function(){
    $("#tooltip ex a").tooltip({
        placement : 'right'
    });
});
</script>
