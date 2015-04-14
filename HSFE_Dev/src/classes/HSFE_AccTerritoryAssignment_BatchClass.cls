/* Class Name : HSFE_AccTerritoryAssignment_BatchClass
*Description :  This class used to assign territory based on zipcode and SAP ID.
*Created By :   Sunil Kumar
*Created On :   04/10/2015

* Modification log:
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Developer                  Date                           Modification Id                       Description
Deloitte/Sunil              4/10/2015                      Created                               
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*
*
*/
public with sharing class HSFE_AccTerritoryAssignment_BatchClass implements Database.Batchable<sObject>, Database.Stateful {
	public List<Account> accountList = new List<Account>();
	public Database.QueryLocator start(Database.BatchableContext BC){
		try{
            //Query all the accounts which contains postalcode.
            
            String query = 'Select id,BillingPostalCode,HSFE_Postal_Code_five_digit__c,HSFE_SAP_ID__c from account where BillingPostalCode!= null';
            system.debug('Query*****>'+query);
            return Database.getQueryLocator(query);// return  accounts.
            
        }catch(Exception e){
            HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception. 
            return null;
        }
	}
	
	public void execute(Database.BatchableContext BC,List<sObject> scope){
		try{
			HSFE_Utility_Class.stopUpdateAccountTerritory = true; //Stop trigger logic for TM.
			Set<String> zipCodeSet = new Set<String>();
			Set<String> postalCodeSet = new Set<String>();
			Set<String> SAPIdSet = new Set<String>();
			Map<Id, Set<String>> accIdToTerrDetailsSetMap = new Map<Id, Set<String>>();
	        Map<Id, Set<Id>> terrIdToUserIdSetMap = new Map<Id, Set<Id>>();
	        Set<Id> tempUserIdSet, fullUserIdSet;
	        Set<String> tempTerritoryDetailsSet;
	        Set<Id> fullTerritoryIdSet = new Set<Id>();
	        Map<String,String> terrExeptionMap = new Map<String,String>();
	        String key, comb, specialty, subSpecialty, combKey;
	        Boolean res;
	        Id terrId;
	        Map<Id, String> userRoleMap = new Map<Id, String>();
	        List<String> terrList;
	        List<HSFE_Account_Territory__c> newAccTerrInsertList = new List<HSFE_Account_Territory__c>();
	    	List<AccountTeamMember> newAccTeamInsertList =  new List<AccountTeamMember>();
	    	HSFE_Account_Territory__c tempAccTerr;
	    	AccountTeamMember tempAccTeam;
	    	Map<String,String> tempZipMap = new Map<String,String>();
	    	List<Account> accList = new List<Account>();
	    	    	
	    	for(Sobject s : scope){
	    		Account a = (Account)s;
	    		if(a.BillingPostalCode != null){
	    			postalCodeSet.add(a.BillingPostalCode);
	    		}    		
	    	}
	    	System.debug('ZipCode**********>'+zipCodeSet); 
	    	for(HSFE_Updated_Zip_Code_Temporary__c tempZip : [select name from HSFE_Updated_Zip_Code_Temporary__c where name=:postalCodeSet]){
	            	tempZipMap.put(tempZip.name,tempZip.name);
	        }
	    	for(Sobject s : scope){
	    		Account a = (Account)s;
	    		if(tempZipMap.containsKey(a.BillingPostalCode)){
	            	accList.add(a);
	            	accountList.add(a);
	            } 
	    	} 
	    	for(Account a : accList){
				if (a.BillingPostalCode != null){
					zipCodeSet.add(a.HSFE_Postal_Code_five_digit__c);
					if(a.HSFE_SAP_ID__c != null && a.HSFE_SAP_ID__c != ''){
						SAPIdSet.add(a.HSFE_SAP_ID__c);
					}
				}
	    	}
	    	if(zipCodeSet.size()>0){
	    		List<HSFE_Territory_Exception__c> TerrExceptionList = new List<HSFE_Territory_Exception__c>([SELECT Id,Name, HSFE_Specialty__c, HSFE_Sub_Specialty__c, HSFE_Territory__c, HSFE_Combination_Key__c FROM HSFE_Territory_Exception__c WHERE Name IN :SAPIdSet]);
	        	for(HSFE_Territory_Exception__c ex:TerrExceptionList){
	        		if(ex.Name != null && ex.HSFE_Specialty__c != null && ex.HSFE_Sub_Specialty__c != null){
	        			terrExeptionMap.put(ex.HSFE_Combination_Key__c, ex.HSFE_Territory__c);
	        		}
	            }
	    		List<HSFE_Zip_To_Territory__c> ZiptoTerrList = new List<HSFE_Zip_To_Territory__c>([SELECT  Id, Name, HSFE_Territory__c, HSFE_Specialty__c, HSFE_Sub_Specialty__c, HSFE_Combination_Key__c FROM HSFE_Zip_To_Territory__c WHERE Name IN :zipCodeSet]);
	    		for(Account ac : accList){
	    			tempTerritoryDetailsSet = new Set<String>();
	            		for(HSFE_Zip_To_Territory__c zipToTerr:ZiptoTerrList){
	            			comb = ':' + zipToTerr.HSFE_Specialty__c + ':'  + zipToTerr.HSFE_Sub_Specialty__c;
	            			if(ac.HSFE_Postal_Code_five_digit__c == zipToTerr.Name){
	            				key = ac.HSFE_SAP_ID__c + zipToTerr.HSFE_Combination_Key__c;
	            				if(terrExeptionMap.containsKey(key)){
	            					tempTerritoryDetailsSet.add(String.valueOf(terrExeptionMap.get(key)) + comb);
	            					fullTerritoryIdSet.add(terrExeptionMap.get(key));
	            				}else{
	            					tempTerritoryDetailsSet.add(String.valueOf(zipToTerr.HSFE_Territory__c) + comb);
	            					fullTerritoryIdSet.add(zipToTerr.HSFE_Territory__c);
	            				}
	            			}
	            		}
	            	accIdToTerrDetailsSetMap.put(ac.id, tempTerritoryDetailsSet);
	    		}
	    		List<HSFE_Territory_To_User__c> terrtoUserList= new List<HSFE_Territory_To_User__c>([SELECT Id,HSFE_Territory__c,HSFE_User__c,HSFE_User_Role__c FROM HSFE_Territory_To_User__c WHERE HSFE_Territory__c IN :fullTerritoryIdSet]);
	            for(HSFE_Territory_To_User__c teToUser: terrtoUserList){
	        		tempUserIdSet = new Set<Id>();
	        		userRoleMap.put(teToUser.HSFE_User__c, teToUser.HSFE_User_Role__c);
	        		if(terrIdToUserIdSetMap.containsKey(teToUser.HSFE_Territory__c)){
	        			tempUserIdSet = terrIdToUserIdSetMap.get(teToUser.HSFE_Territory__c);
						tempUserIdSet.add(teToUser.HSFE_User__c);
						terrIdToUserIdSetMap.put(teToUser.HSFE_Territory__c, tempUserIdSet);
	        		}else{
	        			tempUserIdSet = new Set<Id>();
						tempUserIdSet.add(teToUser.HSFE_User__c);
						terrIdToUserIdSetMap.put(teToUser.HSFE_Territory__c, tempUserIdSet);
	        		}
	            }
	            for(Id accId:accIdToTerrDetailsSetMap.keySet()){
	        		tempTerritoryDetailsSet = accIdToTerrDetailsSetMap.get(accId);
	        		fullUserIdSet = new Set<Id>();
	        		for(String terrDet:tempTerritoryDetailsSet){
	        			terrList = terrDet.split(':');
	        			terrId = Id.valueOf(terrList[0]);
	        			specialty = terrList[1];
	        			subSpecialty = terrList[2];
	        			combKey = String.valueOf(accId).left(15) + specialty + subSpecialty;
	        			tempAccTerr = new HSFE_Account_Territory__c(Account__c = accId,Territory__c=terrId, HSFE_Specialty__c=specialty, HSFE_Sub_Specialty__c=subSpecialty, HSFE_Combination_Key__c = combKey);
	        			newAccTerrInsertList.add(tempAccTerr);
	        			if(terrIdToUserIdSetMap.containsKey(terrId)){
	        				tempUserIdSet = terrIdToUserIdSetMap.get(terrId);
	        				res = fullUserIdSet.addAll(tempUserIdSet);
	        			}
	        		}
	        		for(Id UserId:fullUserIdSet){
	        			String tempRole = '';
	        			if(userRoleMap.containsKey(UserId)){
	        				tempRole = userRoleMap.get(UserId);
	        			}
	        			tempAccTeam = new AccountTeamMember(AccountId = accId,UserId = UserId, TeamMemberRole = tempRole);
		            	newAccTeamInsertList.add(tempAccTeam);
	        		}
	            }
	            List<Database.SaveResult> accterrResult = Database.Insert(newAccTerrInsertList, false);// Insert Account Territory
	            for(Database.SaveResult dsr : accterrResult){
		    	  	if(!dsr.isSuccess()){
		    	  		System.debug('Account Territory Save Result***'+dsr);
		    	  	}
		    	}
		    	List<Database.SaveResult> teamResult = Database.Insert(newAccTeamInsertList, false);// Insert Account Team Member
	            for(Database.SaveResult sr : teamResult){
		    	  	if(!sr.isSuccess()){
		    	  		System.debug('Account Team Memaber Save Result***'+sr);
		    	  	}
		    	}
		    	if(newAccTeamInsertList.size()>0){
	            	List<AccountShare> updateAccountShareList = new List<AccountShare>();
	            	List<AccountShare> shares = [select Id, OpportunityAccessLevel,AccountAccessLevel,AccountId from AccountShare where AccountId IN :accIdToTerrDetailsSetMap.keySet() 
	            								and AccountAccessLevel != 'All' and AccountAccessLevel !='Edit' and RowCause= 'Team'];
	                if(shares.size()>0){
	                    for(AccountShare accshare:shares ){
	                        accshare.AccountAccessLevel='Edit';
	                        accshare.OpportunityAccessLevel='Read';
	                        updateAccountShareList.add(accshare);
	                    }
	                }
	               List<Database.Saveresult> sr = Database.update(updateAccountShareList, false); //Update Account Team member share table.
		        }
	             
	    	}
    	}catch(Exception e){
          HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception. 
        }
    	
	}
	public void finish(Database.BatchableContext ctx){
		HSFE_OppTerritoryAssignment_BatchClass oppBatchObj = new HSFE_OppTerritoryAssignment_BatchClass();
		oppBatchObj.AccountList = accountList; 	
		database.executebatch(oppBatchObj,50);
    
    }
}