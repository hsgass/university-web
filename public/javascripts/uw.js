// Setup the UW [University Web] Namespace
var UW = UW ? UW : new Object();

UW.setupNamespace = function(namespace){
	if(UW[namespace] == undefined)
		UW[namespace] = {}
}

jQuery(function(){
  UW.Preview.init();
});