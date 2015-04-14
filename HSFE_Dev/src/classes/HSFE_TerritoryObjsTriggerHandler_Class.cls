/* Class Name :HSFE_AccountTriggerHandler_Class
*Description :Trigger Handler class for the Account SObject, which implements all the logic of Account trigger.
            1. Update the primary text field on contact based on Is primary checkbox, Primary text field is used in duplicate rules.
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
public with sharing class HSFE_TerritoryObjsTriggerHandler_Class {
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*********************************************Zip To Territory Start*************************************************************************
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
   /*********************************************************************************
     * Method Name:handleZipToTerrAfterUpdate
     * Description:Handle After Update keep track of ZipCodes Updated
     * Return Type: None.
     ********************************************************************************/
    public static void handleZipToTerrAfterUpdate(map<Id, HSFE_Zip_To_Territory__c> newObjMap, map<Id, HSFE_Zip_To_Territory__c> oldObjMap) {
        try{
            set<String> zipCodeUpdatedSet = new set<String>();
            for(Id idVal:newObjMap.keySet()){
                HSFE_Zip_To_Territory__c newObj = newObjMap.get(idVal);
                HSFE_Zip_To_Territory__c oldObj = oldObjMap.get(idVal);
                if(newObj.HSFE_Combination_Key__c ==  oldObj.HSFE_Combination_Key__c && newObj.HSFE_Territory__c != oldObj.HSFE_Territory__c){
                    zipCodeUpdatedSet.add(newObj.Name);
                }
            }
            insertZipCodeSet(zipCodeUpdatedSet);
        }catch(Exception e){
            HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception.
        }
    }
    /*********************************************************************************
     * Method Name:handleZipToTerrBeforeUpdate
     * Description:Handle After Update keep track of ZipCodes Updated
     * Return Type: None.
     ********************************************************************************/
    public static void handleZipToTerrBeforeUpdate(map<Id, HSFE_Zip_To_Territory__c> newObjMap, map<Id, HSFE_Zip_To_Territory__c> oldObjMap) {
        try{
            set<String> zipCodeUpdatedSet = new set<String>();
            for(Id idVal:newObjMap.keySet()){
                HSFE_Zip_To_Territory__c newObj = newObjMap.get(idVal);
                HSFE_Zip_To_Territory__c oldObj = oldObjMap.get(idVal);
                if(newObj.HSFE_Combination_Key__c !=  oldObj.HSFE_Combination_Key__c){
                    newObj.addError('Zip Code, Specialty or Sub Specialty cannnot be changed for an existing record');  
                }
            }
        }catch(Exception e){
            HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception.
        }
    }
    
    /*********************************************************************************
     * Method Name:handleZipToTerrAfterUpdate
     * Description:Handle After Update keep track of ZipCodes Updated
     * Return Type: None.
     ********************************************************************************/
    public static void handleZipToTerrAfterInsertDelete(list<HSFE_Zip_To_Territory__c> objList) {
        try{
            set<String> zipCodeUpdatedSet = new set<String>();
            for(HSFE_Zip_To_Territory__c obj : objList){
                if(obj.Name != null && obj.Name != ''){
                    zipCodeUpdatedSet.add(obj.Name);
                }
            }
            insertZipCodeSet(zipCodeUpdatedSet);
        }catch(Exception e){
            HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception.
        }
    }
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*********************************************Zip To Terriotry End*************************************************************************
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*********************************************Territory Start*************************************************************************
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
    /*********************************************************************************
     * Method Name:handleTerrAfterDelete
     * Description:Handle After delete to keep track of ZipCodes Updated
     * Return Type: None.
     ********************************************************************************/
    public static void handleTerrAfterDelete(list<HSEF_Territory__c> objList) {
        try{
            List<HSFE_Zip_To_Territory__c> zipToTerrList= new List<HSFE_Zip_To_Territory__c>();
            Set<Id> zipcodeSet = new set<Id>();
            set<String> zipCodeUpdatedSet = new set<String>();
           
            for(HSEF_Territory__c terr:objList){
                zipcodeSet.add(terr.Id);
            }
            zipToTerrList = [Select Id,Name,HSFE_Territory__c from HSFE_Zip_To_Territory__c where HSFE_Territory__c IN:zipcodeSet];
            if(zipToTerrList.size()>0){
                for(HSFE_Zip_To_Territory__c obj : zipToTerrList){
                    if(obj.Name != null && obj.Name != ''){
                        zipCodeUpdatedSet.add(obj.Name);
                    }
                }
                insertZipCodeSet(zipCodeUpdatedSet);
                
            }
        }catch(Exception e){
            HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception.
        }
    }
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*********************************************Territory End*************************************************************************
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/




/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*********************************************Territory to User Start*************************************************************************
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
    /*********************************************************************************
     * Method Name:handleUserToTerrAfterInsert
     * Description:Handle After insert to keep track of ZipCodes Updated
     * Return Type: None.
     ********************************************************************************/
    public static void handleUserToTerrAfterInsert(list<HSFE_Territory_To_User__c> objList) {
        try{
            List<HSFE_Zip_To_Territory__c> zipToTerrList= new List<HSFE_Zip_To_Territory__c>();
            Set<Id> terrIdSet = new set<Id>();
            set<String> zipCodeUpdatedSet = new set<String>();
           
            for(HSFE_Territory_To_User__c terr:objList){
                terrIdSet.add(terr.HSFE_Territory__c);
            }
            zipToTerrList = [Select Id,Name,HSFE_Territory__c from HSFE_Zip_To_Territory__c where HSFE_Territory__c IN:terrIdSet];
            if(zipToTerrList.size()>0){
                for(HSFE_Zip_To_Territory__c obj : zipToTerrList){
                    if(obj.Name != null && obj.Name != ''){
                        zipCodeUpdatedSet.add(obj.Name);
                    }
                }
                insertZipCodeSet(zipCodeUpdatedSet);
                
            }
        }catch(Exception e){
            HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception.
        }
    }

    /*********************************************************************************
     * Method Name:handleUserToTerrAfterUpdate
     * Description:Handle After Update to keep track of ZipCodes Updated
     * Return Type: None.
     ********************************************************************************/
    public static void handleUserToTerrAfterUpdate(map<Id, HSFE_Territory_To_User__c> newObjMap, map<Id, HSFE_Territory_To_User__c> oldObjMap) {
        try{
            List<HSFE_Zip_To_Territory__c> zipToTerrList= new List<HSFE_Zip_To_Territory__c>();
            Set<Id> terrIdSet = new set<Id>();
            set<String> zipCodeUpdatedSet = new set<String>();
            
            for(Id idVal:newObjMap.keySet()){
                HSFE_Territory_To_User__c newObj = newObjMap.get(idVal);
                HSFE_Territory_To_User__c oldObj = oldObjMap.get(idVal);
                if(newObj.HSFE_User__c!=  oldObj.HSFE_User__c || newObj.HSFE_Territory__c != oldObj.HSFE_Territory__c){
                     terrIdSet.add(newObj.HSFE_Territory__c);
                }
            }
            zipToTerrList = [Select Id,Name,HSFE_Territory__c from HSFE_Zip_To_Territory__c where HSFE_Territory__c IN:terrIdSet];
            if(zipToTerrList.size()>0){
                for(HSFE_Zip_To_Territory__c obj : zipToTerrList){
                    if(obj.Name != null && obj.Name != ''){
                        zipCodeUpdatedSet.add(obj.Name);
                    }
                }
                insertZipCodeSet(zipCodeUpdatedSet);
                
            }
        }catch(Exception e){
            HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception.
        }
    }
    
    /*********************************************************************************
     * Method Name:handleUserToTerrAfterDelete
     * Description:Handle After Delete to keep track of ZipCodes Updated
     * Return Type: None.
    ********************************************************************************/
    public static void handleUserToTerrAfterDelete(list<HSFE_Territory_To_User__c> objList) {
        try{
            List<HSFE_Zip_To_Territory__c> zipToTerrList= new List<HSFE_Zip_To_Territory__c>();
            Set<Id> terrIdSet = new set<Id>();
            set<String> zipCodeUpdatedSet = new set<String>();
           
            for(HSFE_Territory_To_User__c terr:objList){
                terrIdSet.add(terr.HSFE_Territory__c);
            }
            zipToTerrList = [Select Id,Name,HSFE_Territory__c from HSFE_Zip_To_Territory__c where HSFE_Territory__c IN:terrIdSet];
            if(zipToTerrList.size()>0){
                for(HSFE_Zip_To_Territory__c obj : zipToTerrList){
                    if(obj.Name != null && obj.Name != ''){
                        zipCodeUpdatedSet.add(obj.Name);
                    }
                }
                insertZipCodeSet(zipCodeUpdatedSet);
                
            }
        }catch(Exception e){
            HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception.
        }
    }
    
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*********************************************Territory to User END*************************************************************************
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
    
    
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*********************************************Territory  Exception Start*************************************************************************
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
    /*********************************************************************************
     * Method Name:handleTerrExcepAfterInsertDelete
     * Description:Handle After Insert/Delete to keep track of ZipCodes Updated
     * Return Type: None.
     ********************************************************************************/
    public static void handleTerrExcepAfterInsertDelete(list<HSFE_Territory_Exception__c> objList) {
        try{
            set<String> zipCodeUpdatedSet = new set<String>();
            for(HSFE_Territory_Exception__c obj : objList){
                if(obj.HSFE_Zip_Code__c != null && obj.HSFE_Zip_Code__c != ''){
                    zipCodeUpdatedSet.add(obj.HSFE_Zip_Code__c);
                }
            }
            insertZipCodeSet(zipCodeUpdatedSet);
            
        }catch(Exception e){
            HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception.
        }
    }
    
    
    /*********************************************************************************
     * Method Name:handleTerrExcepAfterUpdate
     * Description:Handle After Update to keep track of ZipCodes Updated
     * Return Type: None.
     ********************************************************************************/
    public static void handleTerrExcepAfterUpdate(map<Id, HSFE_Territory_Exception__c> newObjMap, map<Id, HSFE_Territory_Exception__c> oldObjMap) {
        try{
            set<String> zipCodeUpdatedSet = new set<String>();
            for(Id idVal:newObjMap.keySet()){
                HSFE_Territory_Exception__c newObj = newObjMap.get(idVal);
                HSFE_Territory_Exception__c oldObj = oldObjMap.get(idVal);
                if(newObj.HSFE_Combination_Key__c ==  oldObj.HSFE_Combination_Key__c && newObj.HSFE_Territory__c != oldObj.HSFE_Territory__c){
                    zipCodeUpdatedSet.add(newObj.HSFE_Zip_Code__c);
                }
                system.debug('*****************newObj.HSFE_Territory__c*******************8'+newObj.HSFE_Territory__c);
                system.debug('*****************oldObj.HSFE_Territory__c*******************8'+oldObj.HSFE_Territory__c);
            }
            system.debug('***************zipCodeUpdatedSet***********************8'+zipCodeUpdatedSet);
            insertZipCodeSet(zipCodeUpdatedSet);
        }catch(Exception e){
            HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception.
        }
    }
    
    /*********************************************************************************
     * Method Name:handleTerrExcepBeforeUpdate
     * Description:Handle Before Update to keep track of ZipCodes Updated
     * Return Type: None.
     ********************************************************************************/
    public static void handleTerrExcepBeforeUpdate(map<Id, HSFE_Territory_Exception__c> newObjMap, map<Id, HSFE_Territory_Exception__c> oldObjMap) {
        try{
            set<String> zipCodeUpdatedSet = new set<String>();
            for(Id idVal:newObjMap.keySet()){
                HSFE_Territory_Exception__c newObj = newObjMap.get(idVal);
                HSFE_Territory_Exception__c oldObj = oldObjMap.get(idVal);
                if(newObj.HSFE_Combination_Key__c !=  oldObj.HSFE_Combination_Key__c || newObj.HSFE_Specialty__c !=  oldObj.HSFE_Specialty__c || newObj.HSFE_Sub_Specialty__c    !=  oldObj.HSFE_Sub_Specialty__c    || newObj.HSFE_Zip_Code__c !=  oldObj.HSFE_Zip_Code__c){
                    newObj.addError('Zip Code, Specialty,Sub Specialty or Zip Code cannnot be changed for an existing record');  
                }
            }
            
        }catch(Exception e){
            HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception.
        }
    }
    
   


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*********************************************Territory  Exception END*************************************************************************
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*********************************************Zip Code Temporary Start*************************************************************************
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
    /*********************************************************************************
     * Method Name:insertZipCodeSet
     * Description: Insert unique zip code sets to the temporary table
     * Return Type: None.
     ********************************************************************************/
    public static void insertZipCodeSet(set<String> zipCodeSet) {
        try{
            Map< String, Id > duplicateZipcodeTempMap = new Map< String, Id >();
            List<HSFE_Updated_Zip_Code_Temporary__c> insertZipToTempList = new List<HSFE_Updated_Zip_Code_Temporary__c>();
            
            for( HSFE_Updated_Zip_Code_Temporary__c zipTemprec : [select Id, Name from HSFE_Updated_Zip_Code_Temporary__c where Name = :zipCodeSet] ){
                duplicateZipcodeTempMap.put( zipTemprec.Name, zipTemprec.Id );
            }
            system.debug('**************duplicateZipcodeTempMap*******************'+duplicateZipcodeTempMap);
            for(String tempZipName:zipCodeSet){
                 Id duplicateZipcodeTempId = duplicateZipcodeTempMap.get(tempZipName);
                 if(duplicateZipcodeTempId == null){
                     HSFE_Updated_Zip_Code_Temporary__c Zterr = new HSFE_Updated_Zip_Code_Temporary__c();
                     Zterr.Name = tempZipName; 
                     insertZipToTempList.add(Zterr);
                 }
            }
            system.debug('**************insertZipToTempList*******************'+insertZipToTempList);
            if(insertZipToTempList.size()>0){
                insert insertZipToTempList;
            }
         }catch(Exception e){
            HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception.
        }
    }
/** --------------------------------------------------------------------------------------------------------------------------------------------------------------------
*********************************************Zip Code Temporary End*************************************************************************
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
    
     
}