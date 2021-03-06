JsOsaDAS1.001.00bplist00�Vscript_o(function () {
// JavaScript for the Automation context
var min = 1;
var max = 4;
var default_val = 2;

// get the application TaskPaper
TP = Application("TaskPaper");
// get the standard additions which allow dialogs and other interactions with the system
// if you don't want TP to be the focused app, use Application.currentApplication() and set
// the standard additions to true in that app.
TP.includeStandardAdditions = true;
// note that JXA syntax is just weird, requiring the first parameter like normal, and
// subsequent parameters to be in curly braces with the name of the parameter a colon, then the variable, then a comma. Seems silly to me.
// get the effort required
var effort = TP.displayDialog('Set Effort...('+min+'-'+max+')',{
	withTitle: 'Set Effort for Task',
	defaultAnswer: default_val,
	buttons: ['OK','Cancel'],
	defaultButton: 'OK',
	cancelButton: 'Cancel'
	});
// convert to a number
effort = Number(effort.textReturned);
// check to see if input was valid
if(effort < min || effort > max) {
	return;
}

// get the result
var result = TP.displayDialog('Set Result...('+min+'-'+max+')',{
	withTitle: 'Set Result for Task',
	defaultAnswer: default_val,
	buttons: ['OK','Cancel'],
	defaultButton: 'OK',
	cancelButton: 'Cancel'
	});
// convert to a number
result = Number(result.textReturned);
if(result < min || result > max) {
	return;
}
// calculate the priority
var priority = (effort/result).toFixed(1);


function TaskPaperContextScript(editor, options) {

	// get the priority
	var priority = options;

	// sets the attribute
	function setAttribute(editor, items, name, value) {
	    var outline = editor.outline;
    	var selection = editor.selection;
	    outline.groupUndoAndChanges(function() {
    		items.forEach(function (each) {
		        each.setAttribute(name, value);
			});
		});
		editor.moveSelectionToItems(selection);
	}
	// pass to setAttribute the editor, the selectedItems
	setAttribute(editor, editor.selection.selectedItems, 'data-priority', priority);
}

// call the JavaScript
Application("TaskPaper").documents[0].evaluate({
  script: TaskPaperContextScript.toString(),
  withOptions: priority
})
})();                              � jscr  ��ޭ