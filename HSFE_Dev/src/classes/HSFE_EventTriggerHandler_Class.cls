/************************************************************************************** 
 Apex Class  Name    : HSFE_EventTriggerHandler_Class
 Version             : 1.0 
 Created Date        : 12 April 2015
 Function            : Helper class for trigger
 Modification Log    :
 * Developer                      Date                                    Description
 * ----------------------------------------------------------------------------                 
 * Kumar Gaurav                04/12/2014                              Original Version
 *************************************************************************************/
public class HSFE_EventTriggerHandler_Class {
	
	/*
     * Method name  : handleLotusNotesUpdate
     * Description  : This method is called when the salesrep creates an event in salesforce
     * Return Type  : None
     * Parameter    : None
     */ 
     public static void handleLotusNotesUpdate(List<Event> evdList){
     	Set<Id> evdIds = new Set<Id>();
     	Map<Id,String> oppIdAccNameMap = new Map<Id, String>();
     	String mType = null;
     	for(Event evd : evdList){
     		if(evd.WhatId != null && evd.Type == HSFE_Constant.MEETING  && evd.WhatId.getSObjectType().getDescribe().getName() == Opportunity.sObjectType.getDescribe().getLabel()){
     			system.debug('WhatId -- > '+evd.WhatId + ' Type -> '+ evd.WhatId.getSObjectType().getDescribe().getName());
     			if(evd.Id != null){
     				evdIds.add(evd.Id);
     			}
     			if(Trigger.isbefore){
     				evd.Modified_By_Mule__c = false;
     			}
     			if(String.isEmpty(evd.Lotus_Note_Id__c)){
     				 oppIdAccNameMap.put(evd.WhatId,null);
     			}
     		}
     	}
     	//read all what Ids and change the subject if trigger is IsBefore and IsUpdate
     	If(!oppIdAccNameMap.isEmpty() && Trigger.isbefore && Trigger.isInsert){
 			for(Opportunity opp : [Select Id, Account.name from Opportunity where Id IN: oppIdAccNameMap.keyset()]){
 				oppIdAccNameMap.put(opp.Id, opp.account.name);
 			}
 			for(Event evd : evdList){
     			if(oppIdAccNameMap.containsKey(evd.WhatId)){
     				mType = evd.Meeting_Type__c == null ? '' : evd.Meeting_Type__c;
     				evd.Subject = oppIdAccNameMap.get(evd.WhatId)+ '_'+ mType;
     			}
     		}
 		}
     	system.debug('evdIds -- > '+evdIds);
     	if(!System.isFuture() && !evdIds.isEmpty()){
     		// create the callout request
     		List<Id> ls = new List<Id>(evdIds);
     		system.debug('Service called evdIds -- > '+evdIds + ' --- ' +evdIds.size());
     		HSFE_SendEventToLotusNotes.createOrUpdateCalendarInNotes(ls);
     	}
     }
}