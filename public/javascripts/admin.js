$(document).ready(function(){
  
  $(".sortable").sortable({
    axis: 'y',
    stop: function(s){
      url = $(this).attr('data-remote') + '?' + $(this).sortable('serialize');
      data = {authenticity_token: authenticity_token}
      $.post(url, data );
      }
  });

  $("#site-map").treeTable();

  $.ui.dialog.defaults.bgiframe = true;
  $(".dialog").each(function(dialog){
    form = $(this).find('form').get(0);
    buttons = {};
    $(this).find('button').each(function(){
      buttons[this.innerHTML] = function(){ form.submit() };
      $(this).remove();
    })
    $(this).dialog({ autoOpen: false, buttons: buttons, resizeable: true })
  });

})




function showNewPageDialog(parent_id, page_types)
{
  $('#page_title').get(0).value = '';

  // Set parent
  $.each($('#page_parent_id').get(0).options, function(index){
    if(this.value == parent_id){
      $('#page_parent_id').get(0).selectedIndex = index;
    }
  })

  // Populate type select
  ts = $('#type_select').get(0);
  ts.innerHTML = '';
  $.each(page_types, function(){
    option = new Option();
    option.value = this;
    option.text = this.replace('_',' ');
    ts.options[ts.options.length] = option;    
  });

  $('#new_page_dialog').dialog('open');

}
