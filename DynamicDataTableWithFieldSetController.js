({
	doInit : function(component, event, helper) {
		
		var action = component.get('c.getAccounts');
		action.setParams({'strObjectName' : 'Account',
						'strFieldSetName' : 'MyFieldSet'});
		action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS') {

            	component.set('v.myData', response.getReturnValue().lstDataTableResponse);
            	component.set('v.columns', response.getReturnValue().lstDataColumns);
            	  }
            	  else if (state === 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }else{
                console.log('Something went wrong, Please check with your admin');
            }
        });
        $A.enqueueAction(action);
	}
})