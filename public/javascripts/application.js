
// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var TWITTER_MESSAGE_LIMIT = 140;
var START_COLOUR = 'FFFFFF';
var END_COLOUR = 'F61F02';

// An extension to Prototype to allow for cross-browser getting and setting of
// text within elements. Taken from: http://blog.igrokthat.net/?p=25
Element.addMethods({
    getInnerText: function(element) {
       element = $(element);
       return (element.innerText || element.textContent);
    },

    setInnerText: function(element, value) {
        element = $(element);
        if (element.innerText)
            element.innerText = value;
        else
            element.textContent = value;
        return element;
    }
});

// My function to check the CheckBoxes used for disabling/enabling the title text
// area. This has hard coded element IDs.
function checkCheckBoxes() {
	var setFalse = false;
	var color = 'white'
	var email = document.getElementById("feeds_email");
	var blog = document.getElementById("feeds_blog");
	var twitter = document.getElementById("feeds_twitter");
	var fb = document.getElementById("feeds_facebook");
	if(twitter.checked == true || fb.checked == true) {
		setFalse = true;
		color = 'grey'
	}
	if(email.checked == true || blog.checked == true) {
		color = 'white'
		setFalse = false
	}
	document.getElementById("broadcast_title").disabled = setFalse;
	document.getElementById("broadcast_title").value = "";
	document.getElementById("broadcast_title").style.backgroundColor = color
}

// Here's some code to initialise Tiny_mce rich text editor for text areas

function initTinyMCE(){
    tinyMCE.init({
            //mode : "none",
            mode : "specific_textareas",
            editor_selector : "mceEditor",
            theme : "advanced",
            content_css : "/stylesheets/cs-alumni.css",
            convert_urls : false,
            plugins : "emotions,preview",
            theme_advanced_buttons1 : "bold,italic,underline,separator,strikethrough,bullist,numlist,link",
            theme_advanced_buttons2 : "",
            theme_advanced_buttons3 : "",
            theme_advanced_toolbar_location : "top",
            theme_advanced_toolbar_align : "left",
            extended_valid_elements : "a[name|href|target|title|onclick],img[class|src|border=0|alt|title|hspace|vspace|width|height|align|onmouseover|onmouseout|name],hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]"
        });
}

//initTinyMCE();

     
 var tinyMCEmode = false;

 // A hack solution to toggle the TinyMCE editor display. We go poking
 // about in the DOM tree using prototype helper methods and knowing
 // the style class name used for the SPAN element created by TinyMCE.
 // Since TinyMCE changed the id attribute on our textarea we are forced to
 // find it some other way, hence the use of the text areas name attribute
 // textAreaName and we focus the search by identifying the containing
 // element (probably a div)! There were solution suggested online to use
 // tinyMCE.addMCEControl and tinyMCE.removeMCEControl but I couldn't
 // get these to work and I'm not convinced the methods even exist any more
 function toogleEditorMode(containingElementId, textAreaName, twitterCounter) {
   if(tinyMCEmode) {
     var spanElements = $(containingElementId).select('[class="mceEditor defaultSkin"]');
     if (spanElements.length > 0){
       var textAreaElements = $(containingElementId).select('[name="' + textAreaName + '"]');

       if (textAreaElements.length > 0){
          // Transfer content of span across to the textarea
          var spanContent = tinyMCE.activeEditor.getContent();
          textAreaElements[0].value = spanContent;
          
          // Remove the current TinyMCE span
          spanElements[0].remove();

          // Remove the style attribute so display:none is removed and textarea
          // reappears
          textAreaElements[0].removeAttribute('style');

          // Set class to nothing to avoid TinyMCE from recognising the textarea
          // when it is reinitialised
          textAreaElements[0].className = '';


          // Reset background colour of textarea and twitterCounter value
          twitterCharCountEffect(containingElementId, textAreaName, twitterCounter);
       }   
     }
     tinyMCEmode = false;
   } else {
     textAreaElements = $(containingElementId).select('[name="' + textAreaName + '"]');
     if (textAreaElements.length > 0){
        // Following doesn't work in IE. The cross-browser way to set is to use className = value
        // textAreaElements[0].setAttribute('class', 'mceEditor');
        textAreaElements[0].className = 'mceEditor';
     }
     tinyMCEmode = true;
   }
   // A crude way to reinitialise tinyMCE at runtime   
   initTinyMCE();
 }

 // main function to process the fade request //
function colourAlerter(target, styleName, start, end, steps, position) {
  var startrgb,endrgb,eg,eb,gint,bint,r,g,b;
  
  endrgb = colourConv(end);

  // Only alter the green and blue components. Key red as is.
  eg = endrgb[1];
  eb = endrgb[2];
  
  startrgb = colourConv(start);
  r = startrgb[0];
  g = startrgb[1];
  b = startrgb[2];
    
  gint = Math.round(Math.abs(g-eg)/steps);
  bint = Math.round(Math.abs(b-eb)/steps);
  
  if(gint == 0) { gint = 1 }
  if(bint == 0) { bint = 1 }

  if (g >= 0 && b >= 0){
    g = g - gint * position;
    b = b - bint * position;
  } else {
    g = 0;
    b = 0;
  }
  
  colour = 'rgb(' + r + ',' + g + ',' + b + ')';
  if(styleName == 'background') {
    target.style.backgroundColor = colour;
  } else if(styleName == 'border') {
    target.style.borderColor = colour;
  } else {
    target.style.color = colour;
  }
}

// Convert the color to rgb from hex //
function colourConv(colour) {
  var rgb = [parseInt(colour.substring(0,2),16),
             parseInt(colour.substring(2,4),16),
             parseInt(colour.substring(4,6),16)];
  return rgb;
}


 function twitterCharCountEffect(containingElementId, textAreaName, twitterCounter){
   
   // Every time there's a character typed we must recalculate the number of characters
   // in the text area and set the background colour of the text area to indicate
   // how close we are to the Twitter 140 maximum and also reset the twitterCounter
   // value and it's colour
   textAreaElements = $(containingElementId).select('[name="' + textAreaName + '"]');
   if (textAreaElements.length > 0){
       // Set the counter value
       var count = textAreaElements[0].value.length;
       $(twitterCounter).setInnerText(TWITTER_MESSAGE_LIMIT - count);

       // Change the background colour for the counter label and text area
       //alert('TWITTER_MESSAGE_LIMIT - count: ' + (TWITTER_MESSAGE_LIMIT - count));
       colourAlerter(textAreaElements[0], 'background', START_COLOUR,
                     END_COLOUR, TWITTER_MESSAGE_LIMIT, count);
       if (TWITTER_MESSAGE_LIMIT - count+1 <= 0){
         $(twitterCounter).style.color = '#' + END_COLOUR;
       }else{
         $(twitterCounter).style.color = 'black';
       }
   }
 }
       

var q_auto_completer; // Must be assigned a value through calling new Ajax.UsersAutocompleter
                      // somewhere in the app

/* Callback function called by Ajax.Autocompleter to place the list item
 * text value selected into the text field with id="q"
 */
function processUpdate(listItem){
   textField = $("q");
   textField.value = listItem.childNodes[3].lastChild.nodeValue.strip();
}

/* Use Prototypes's Class.create method to override the original hide method
* so that we can keep the dropdown autocompletion box visible if a link is
* clicked in the dropdown list rather than the text. This keeps the list up
* so the user can keep displaying the details of individuals until they click on the non
* image part of the link. We arrange for remote_image_for to set doHide property to false
* if the image link is clicked
*/
Ajax.UsersAutocompleter = Class.create(Ajax.Autocompleter, {

    initialize: function($super, element, update, url, options) {
       $super(element, update, url, options);
       this.doHide = true; // By default we hide the list after a click
    },

    setToBeHidden: function(value){
       this.doHide = value;
    },

    isToBeHidden: function(){
       return this.doHide;
    },

    hide: function($super) {
      if (this.isToBeHidden()){
        $super();
      } // else nothing
    }
});



