({
    callImagePredictor : function(component, event, helper) {
        var files = event.getSource().get("v.files");
        var file = files[0];
        var fr = new FileReader();
        var self = this;
           fr.onload = function() {
            var fileContents = fr.result;
            var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            fileContents = fileContents.substring(dataStart);
            self.upload(component, file, fileContents);
        };
        fr.readAsDataURL(file);    
    },

    upload: function(component, file, fileContents) {
        var action = component.get("c.predict"); 
 
        action.setParams({
            fileName: file.name,
            base64Data: encodeURIComponent(fileContents), 
            contentType: file.type,
            modelId : 'PFCOJICP2VD4LYV5M3O4A2XVLU'
        });
 
        action.setCallback(this, function(response) {
           var result = response.getReturnValue();
            console.log(result);
        });
         $A.enqueueAction(action); 
    }
})