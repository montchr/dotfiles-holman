JsOsaDAS1.001.00bplist00�Vscript_�function TaskPaperContextScript(editor, options) {
	var outline = editor.outline;
	// group all the changes together into a single change and make it a single "undo" action
	outline.groupUndoAndChanges(function () {
		// all the projects
		var projects_array = outline.evaluateItemPath('@type=project except archive:');
		// for each project get the tasks with priority
		projects_array.forEach(function(each) {
			var has_children = each.hasChildren;
			if(!has_children) {
				return;
			}
			var children = each.children; 

			// handle the case of only one item in a project
			if(children.length < 2) {
				return;
			}

			children.sort(function (a, b) {
				// a and b are elements of the array
				// get the priority value of task a, "getAttribute" takes the attribute name,
				// and whether or not the value should be converted to something else (in
				// this case a number)
				//debugger;
				var a_priority = a.getAttribute('data-priority', Number);
				var b_priority = b.getAttribute('data-priority', Number);
				//var a_has_done = a.hasAttribute('data-done');
				//var b_has_done = b.hasAttribute('data-done');

				// need to return negative, zero, or positive
				// negative indicates a < b
				// zero indicates a = b
				// positive indicates a > b
				
				// Here null means the item didn't have a priority tag
				// In this case b < a
				if(a_priority == null && b_priority != null) {
					return 1 ;
				} // In this case a < b
				else if (a_priority != null && b_priority == null) {
					return -1;
				} // In thise case a = b
				else if (a_priority == null && b_priority == null) {
					return 0;
				} // In thise return a relative to b
				else {
					return a_priority - b_priority;
				}
			});	// end sort	
			each.removeChildren(each.children);
			each.appendChildren(children);
		}); // end projects_array.forEach 
	}); // end outline.groupUndoAndChanges
} // end TaskPaperContextScript

var string = Application("TaskPaper").documents[0].evaluate({
  script: TaskPaperContextScript.toString()
});

                              jscr  ��ޭ