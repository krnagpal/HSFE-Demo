/* Class Name :HSFE_AccTeamDelete_BatchClass
*Description :This class is used to delete all the 
*Created By :Sourav Datta
*Created On :03/17/2015

* Modification log:
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Developer                  Date                           Modification Id                       Description
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*
*
*/
public with sharing class HSFE_AccTeamDelete_BatchClass implements Database.Batchable<sObject>, Database.Stateful{
	public Database.QueryLocator start(Database.BatchableContext BC){
		try{
            //Query all the accounts which contains postalcode.
            
            String query = 'Select id,BillingPostalCode from account where BillingPostalCode!= null';
            system.debug('Query*****>'+query);
            return Database.getQueryLocator(query);// return  accounts.
            
        }catch(Exception e){
            HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception. 
            return null;
        }
	
	}
	public void execute(Database.BatchableContext BC,List<sObject> scope){
		try{
			Set<String> accSetId = new Set<String>();
			Set<String> postalCodeSet = new Set<String>();
			Map<String,String> tempZipMap = new Map<String,String>();
			for(Sobject s : scope){
	    		Account a = (Account)s;
	    		if(a.BillingPostalCode != null){
	    			postalCodeSet.add(a.BillingPostalCode);
	    		}    		
	    	}
	    	for(HSFE_Updated_Zip_Code_Temporary__c tempZip : [select name from HSFE_Updated_Zip_Code_Temporary__c where name=:postalCodeSet]){
	            	tempZipMap.put(tempZip.name,tempZip.name);
	        }
	        for(Sobject s : scope){
				Account a = (Account)s;
				if(tempZipMap.containsKey(a.BillingPostalCode)){
					accSetId.add(a.id);
				}		
			}
			List<AccountTeamMember> toDeleteTeam = new List<AccountTeamMember>([SELECT Id,AccountId  FROM AccountTeamMember WHERE AccountId IN :accSetId]); 
			List<HSFE_Account_Territory__c> toDeleteAccountTerr = new List<HSFE_Account_Territory__c>([SELECT Id,Account__c FROM HSFE_Account_Territory__c WHERE Account__c IN :accSetId]);//Delete account territory.
			List<Database.DeleteResult> teamResult = Database.delete(toDeleteTeam, false); //Delete account team members.
			List<Database.DeleteResult> accterrResult = Database.delete(toDeleteAccountTerr, false); //Delete account team members.
			System.debug('**** Team Member Save Result : '+teamResult);
			System.debug('**** Account Territory Save Result : '+teamResult);             
	        for(Database.DeleteResult err : teamResult){        	               
	            if(!err.isSuccess()){
	            	System.debug('Account Team Delete Result******'+err);
	            }
	        	
	        }
	        for(Database.DeleteResult re:accterrResult){
	        	if(!re.isSuccess()){
	        		System.debug('Account Territory Delete Result******'+re);
	        	}    	                  
	            
	        }
        }catch(Exception e){
          HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception. 
        }
		
	 
	}
	public void finish(Database.BatchableContext ctx){
    	HSFE_AccTerritoryAssignment_BatchClass accTerrAssignObj = new HSFE_AccTerritoryAssignment_BatchClass();
    	database.executebatch(accTerrAssignObj,50);
    }

}