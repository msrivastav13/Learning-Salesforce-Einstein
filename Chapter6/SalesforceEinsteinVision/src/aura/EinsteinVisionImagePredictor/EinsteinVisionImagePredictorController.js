({
	handleFilesChange : function(component, event, helper) {
		var files = event.getSource().get("v.files");
        console.log(files[0]);
	}
})