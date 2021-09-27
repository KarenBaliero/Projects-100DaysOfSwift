var Action = function() { }

Action.prototype = {
//before loading
run: function(parameters){
    parameters.completionFunction({"URL": document.URL, "title": document.title});
},
//after loading
finalize: function(parameters){
    var customJavaScript = parameters["customJavaScript"]
    //will run the script
    eval(customJavaScript)
}
};

var ExtensionPreprocessingJS = new Action
