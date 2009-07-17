$.fn.ajaxGetLink = function(target){
  var collection = this;
  this.each(function(){
    $(this).click(function(){
      target.load( this.href );
      return false;
    })
  });
}

$(document).ready(function(){
  
  $(".ui-tabs").tabs({
    load: function(event, ui) { doContentLoaded() }
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

  $("body").ajaxComplete(function(){

    $("#content_browser .pagination a").ajaxGetLink($("#content_browser .results"));

  })
  
  doContentLoaded();
  
})

function doContentLoaded()
{

  $("#content_browser > form").submit(function(){
    data = $(this).serialize();
    $("#content_browser .results").load(this.action, data, function(){
      $("#content_browser .results form").submit(function(){
        data = $(this).serializeArray();
        $.post(this.action, data, null, 'script');
        return false;
      });
    });
    return false;
  });  

  $(".sortable").sortable({
    axis: 'y',
    stop: function(s){
      url = $(this).attr('data-remote') + '?' + $(this).sortable('serialize');
      data = {authenticity_token: authenticity_token}
      $.post(url, data );
      }
  });  

}



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
