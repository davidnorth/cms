$(document).ready(function(){
  
  $(".sortable").sortable({
    axis: 'y',
    stop: function(s){
      url = $(this).attr('data-remote') + '?' + $(this).sortable('serialize');
      data = {authenticity_token: authenticity_token}
      $.post(url, data );
      }
  });

  $(".tree_table").treeTable();

})


