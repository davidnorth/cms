
var RuledTable = Class.create();
RuledTable.prototype = {
  
  initialize: function(element_id) {
    var table = $(element_id);
    var rows = table.getElementsByTagName('tr');
    for (var i = 0; i < rows.length; i++) {
      this.setupRow(rows[i]);
    }
  },
  
  onMouseOverRow: function(event) {
    // Element.addClassName(this, 'highlight');
    this.className = this.className.replace(/\s*\bhighlight\b|$/, ' highlight'); // faster than the above
  },
  
  onMouseOutRow: function(event) {
    // Element.removeClassName(this, 'highlight');
    this.className = this.className.replace(/\s*\bhighlight\b\s*/, ' '); // faster than the above
  },
  
  setupRow: function(row) {
    Event.observe(row, 'mouseover', this.onMouseOverRow.bindAsEventListener(row));
    Event.observe(row, 'mouseout', this.onMouseOutRow.bindAsEventListener(row));
    if (this.onRowSetup) this.onRowSetup(row);
  }
  
};



var SiteMap = Class.create();

SiteMap.prototype = Object.extend({}, RuledTable.prototype); // Inherit from RuledTable
Object.extend(SiteMap.prototype, {

  expandedRows: [],

  onRowSetup: function(row) {
    Event.observe(row, 'click', this.onMouseClickRow.bindAsEventListener(this), false);
  },
  
  onMouseClickRow: function(event) {
    var element = Event.element(event);
    if (this.isExpander(element)) {
      var row = Event.findElement(event, 'tr');
      if (this.hasChildren(row)) {
        this.toggleBranch(row, element);
      }
    }
  },
  
  hasChildren: function(row) {
    return ! /\bno-children\b/.test(row.className);
  },
  
  isExpander: function(element) {
    return (element.tagName.strip().downcase() == 'img') && /\bexpander\b/i.test(element.className);
  },
  
  isExpanded: function(row) {
    return /\bchildren-visible\b/i.test(row.className);
  },
  
  isRow: function(element) {
    return element.tagName && (element.tagName.strip().downcase() == 'tr');
  },
  
  extractLevel: function(row) {
    if (/level-(\d+)/i.test(row.className))
      return RegExp.$1.toInteger();
  },
  
  extractPageId: function(row) {
    if (/page-(\d+)/i.test(row.id))
      return RegExp.$1.toInteger();
  },
  
  getExpanderImageForRow: function(row) {
    var images = $A(row.getElementsByTagName('img', row));
    var expanders = [];
    images.each(function(image){
      expanders.push(image);
    }.bind(this));
    return expanders.first();
  },     
  
  saveExpandedCookie: function() {
    document.cookie = "expanded_rows="+this.expandedRows.join(",")+"; path=/admin";
  }, 
  
  hideBranch: function(row, img) {
    var level = this.extractLevel(row);
    var sibling = row.nextSibling;
    while(sibling != null) {
      if (this.isRow(sibling)) {
        if (this.extractLevel(sibling) <= level) break;
        Element.hide(sibling);
      }
      sibling = sibling.nextSibling;
    }
    var pageId = this.extractPageId(row);
    var newExpanded = [];
    for(i=0; i < this.expandedRows.length; i++)
        if(this.expandedRows[i] != pageId)
            newExpanded.push(this.expandedRows[i]);
    this.expandedRows = newExpanded;
    this.saveExpandedCookie();
    if (img == null)
      img = this.getExpanderImageForRow(row);
    img.src = img.src.replace(/collapse/, 'expand');
    Element.removeClassName(row, 'children-visible');
    Element.addClassName(row, 'children-hidden');
  },
  
  hideBranchByNumber: function(number) {
    this.hideBranch($('page-'+number),$('expander-'+number));
  },
  
  showBranchInternal: function(row, img) {
    var level = this.extractLevel(row);
    var sibling = row.nextSibling;
    var children = false;
    var childOwningSiblings = [];        
    while(sibling != null) {
      if (this.isRow(sibling)) {
        var siblingLevel = this.extractLevel(sibling);
        if (siblingLevel <= level) break;
        if (siblingLevel == level + 1) {
          Element.show(sibling);
          if(sibling.className.match(/children-visible/)) {
            childOwningSiblings.push(sibling);
          } else {
            this.hideBranch(sibling);
          }
        }
        children = true;
      }
      sibling = sibling.nextSibling;
    }
    if (!children)
      this.getBranch(row);
    if (img == null)
      img = this.getExpanderImageForRow(row);          
    img.src = img.src.replace(/expand/, 'collapse');
    for(i=0; i < childOwningSiblings.length; i++) {
        this.showBranch(childOwningSiblings[i], null);            
    }        
    Element.removeClassName(row, 'children-hidden');
    Element.addClassName(row, 'children-visible');
  },
  
  showBranch: function(row, img) {
    this.showBranchInternal(row, img);
    this.expandedRows.push(this.extractPageId(row));
    this.saveExpandedCookie();
  },
  
  toggleBranch: function(row, img) {
    if (! this.updating) {
      if (this.isExpanded(row)) {
        this.hideBranch(row, img);
      } else {
        this.showBranch(row, img);
      }
    }
  }

});





// For image picker widgets
function pickImage(field_id)
{
  imageLibraryCallback = function(image){
    $(field_id).value = image.id;
    $(field_id + "_preview").src = image.thumb_src;
    imageLibraryDialog.close();
  }
  PopUp.imageLibraryDialog();
}
// For adding to multiple image lists
function addImage()
{
  imageLibraryCallback = function(image,popup){    
    new Ajax.Request('/admin/pages/add_image?image='+image.id, {asynchronous:true, evalScripts:true});
  };
  PopUp.imageLibraryDialog();
}

// For WYSIWYG editors
function insertImage(theIframe)
{
  imageLibraryCallback = function(image){
    widgInsertImage(theIframe, image.src, image.alt);
  }
  PopUp.imageLibraryDialog();
}
// File upload picker widget
function pickFile()
{
  PopUp.fileUploadDialog()
  fileUploadLibraryCallback = function(file_upload,popup_window){
    filePickerDialog = popup_window;
    new Ajax.Updater('fileUploadsList', 
      '/admin/pages/add_file_upload?file_upload=' + file_upload.file_upload_id, 
      { asynchronous:true, evalScripts:true }
    );
  }
}
// For document link button in WYSIWYG
function insertFile()
{
  // window.opener.widgInsertDocumentLink(window.opener.theIframeForDocumentLink, src, filename, filetype);
}

var PopUp = function(){}
PopUp.makeFeatures = function(w,h)
{
	l = (screen.width/2) - (w/2);
	t = (screen.height/2) - (h/2);
	return "resizable=1,scrollbars=1,width=" + w + ",height=" + h + ",top=" + t + ",left=" + l;
}
PopUp.open = function(url,name,w,h)
{
	window[name] = window.open(url, name, PopUp.makeFeatures(w,h));
}
PopUp.fileUploadDialog = function()
{
  PopUp.open("/admin/file_uploads?popup=1", "fileUploadDialog", 640, 480);
}
PopUp.imageLibraryDialog = function(field_id)
{
  PopUp.open("/admin/images?popup=1", "imageLibraryDialog", 640, 480);
}







function visibilityToggle(link,element_id)
{  
  if(Element.visible(element_id)){
    Element.hide(element_id);
    link.innerHTML = link.innerHTML.replace(/Hide/,'Show');
  }
  else {
    Element.show(element_id);
    link.innerHTML = link.innerHTML.replace(/Show/,'Hide');
  }
}





function showTypeChooser()
{
  args = $A(arguments);
  parent_id = args.shift();

  ts = $('type_select');
  ts.innerHTML = '';

  args.each(function(type_name){
    option = new Option();
    option.value = type_name;
    option.text = type_name.gsub(/_/,' ').capitalize();
    ts.options[ts.options.length] = option;
    
  });
  $('type_chooser_button').onclick = function(){
    chooseType(parent_id);
  }
  window_width = window.innerWidth || (window.document.documentElement.clientWidth || window.document.body.clientWidth);
  x = Math.round( (window_width / 2) - ($('type_chooser').getWidth() / 2) );
  $('type_chooser').setStyle({ left: x+'px' });
  $('type_chooser').show();
}
function chooseType(parent_id)
{
  ts = $('type_select');
  url = '/admin/pages/new?parent=' + parent_id + '&type=' + ts.options[ts.selectedIndex].value;
  window.location = url;
}