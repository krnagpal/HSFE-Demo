/************************************************************************************** 
 Trigger Name        : HSFE_Event_TriggerHandler
 Version             : 1.0 
 Created Date        : 12 April 2015
 Function            : This trigger will perform any customization on event records during any insert or update events
 Modification Log    :
 * Developer                      Date                                    Description
 * ----------------------------------------------------------------------------                 
 * Kumar Gaurav                04/12/2014                              Original Version
 *************************************************************************************/
trigger HSFE_Event_TriggerHandler on Event (before insert, after insert, before update) {
	// Skip method for Integration profile AND validate if trigger needs to be executed
    if (ProfileWithNoExecution__c.getValues(UserInfo.getProfileId()) != null) {
        return;
    } 
    if (!HSFE_Utility_Class.hasAlreadyExecuted()) { 
        HSFE_EventTriggerHandler_Class.handleLotusNotesUpdate(trigger.new);
        if(Trigger.isAfter){
        	HSFE_Utility_Class.setAlreadyExecuted();
        }
    }
}