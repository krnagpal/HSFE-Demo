/* Trigger Name :HSFE_Territory_TriggerHandler 
*Description:This trigger calls a HSFE_TerritoryObjsTriggerHandler_Class to execute the trigger logic
*Created By :Chiranth Aradhya
*Created On :04/13/2015

* Modification log:
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Developer                  Date                           Modification Id                       Description
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*
*
*/
trigger HSFE_Territory_TriggerHandler on HSEF_Territory__c (after delete) {
    
    if(trigger.isAfter){
        if(trigger.isDelete){
           HSFE_TerritoryObjsTriggerHandler_Class.handleTerrAfterDelete(trigger.old);
        }
    }
}