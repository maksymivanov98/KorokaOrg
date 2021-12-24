({
    handleClick : function (cmp, event, helper) {
        alert("You clicked: " + event.getSource().get("v.label"));
        let eventSource = event.getSource();
        concole.log(event.getSource().get("v.label"));
        concole.log(event.getSource().get("v.title"));
        
       // componetn.set("v.buttonText", eventSource.label);
    }
});