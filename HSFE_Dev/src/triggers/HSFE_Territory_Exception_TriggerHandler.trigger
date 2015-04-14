/***********************************
* Trigger Name :HSFE_Territory_Exception_TriggerHandler 
*Description:This trigger calls a HSFE_TerritoryObjsTriggerHandler_Class to execute the trigger logic
*Created By :Sourav Datta
*Created On :04/08/2015

* Modification log:
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Developer                  Date                           Modification Id                       Description
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*
*
*/
trigger HSFE_Territory_Exception_TriggerHandler on HSFE_Territory_Exception__c (after delete, after insert, after update, before update) {
    
    if(trigger.isAfter){
        if(trigger.isInsert){
            HSFE_TerritoryObjsTriggerHandler_Class.handleTerrExcepAfterInsertDelete(trigger.new);
        } else if(trigger.isUpdate){
            HSFE_TerritoryObjsTriggerHandler_Class.handleTerrExcepAfterUpdate(trigger.newMap, trigger.oldMap);
        } else if(trigger.isDelete){
            HSFE_TerritoryObjsTriggerHandler_Class.handleTerrExcepAfterInsertDelete(trigger.old);
        }
    }
    if(trigger.isBefore){
        if(trigger.isUpdate){
            HSFE_TerritoryObjsTriggerHandler_Class.handleTerrExcepBeforeUpdate(trigger.newMap, trigger.oldMap);
        }
    }
   
}