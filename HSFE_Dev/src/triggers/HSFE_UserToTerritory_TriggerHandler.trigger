/* Trigger Name :HSFE_UserToTerritory_TriggerHandler 
*Description:This trigger calls a HSFE_TerritoryObjsTriggerHandler_Class to execute the trigger logic
*Created By :Chiranth Aradhya
*Created On :04/14/2015

* Modification log:
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Developer                  Date                           Modification Id                       Description
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*
*
*/
trigger HSFE_UserToTerritory_TriggerHandler on HSFE_Territory_To_User__c (after delete, after insert, after update) {
    if(trigger.isAfter){
            if(trigger.isInsert){
                HSFE_TerritoryObjsTriggerHandler_Class.handleUserToTerrAfterInsert(trigger.new);
            } else if(trigger.isUpdate){
                HSFE_TerritoryObjsTriggerHandler_Class.handleUserToTerrAfterUpdate(trigger.newMap, trigger.oldMap);
            } else if(trigger.isDelete){
                HSFE_TerritoryObjsTriggerHandler_Class.handleUserToTerrAfterDelete(trigger.old);
            }
    }
}