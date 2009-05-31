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

  $.ui.dialog.defaults.bgiframe = true;
  $(".dialog").each(function(dialog){
    form = $(this).find('form').get(0);
    buttons = {};
    $(this).find('button').each(function(){
      buttons[this.innerHTML] = function(){ form.submit() };
      $(this).remove();
    })
    $(this).dialog({ autoOpen: false, buttons: buttons })
  });

})




function showNewPageDialog()
{
  args = $.makeArray(arguments);
  parent_id = args.shift();

  $('#page_title').get(0).value = '';
  $('#new_page_dialog').dialog('open');

  ts = $('#type_select').get(0);
  ts.innerHTML = '';

  $.each(args, function(){
    option = new Option();
    option.value = this;
    option.text = this.replace('_',' ');
    ts.options[ts.options.length] = option;    
  });
}
