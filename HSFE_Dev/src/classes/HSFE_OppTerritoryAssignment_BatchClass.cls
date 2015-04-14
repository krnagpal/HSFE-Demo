/* Class Name : HSFE_OppTerritoryAssignment_BatchClass
*Description :  This class used to assign territory based on zipcode and SAP ID.
*Created By :   Sunil Kumar
*Created On :   04/13/2015

* Modification log:
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Developer                  Date                           Modification Id                       Description
Deloitte/Sunil              4/13/2015                      Created                               
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*
*
*
*/
public with sharing class HSFE_OppTerritoryAssignment_BatchClass implements Database.Batchable<sObject>, Database.Stateful{
	public List<Account> AccountList;
	
	public Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator([SELECT Id, OwnerId, HSFE_Territory__c, HSFE_Combination_Key__c, HSFE_Sub_Specialty__c, HSFE_Specialty__c, AccountId,CreatedById FROM Opportunity WHERE AccountId IN : AccountList and HSFE_Specialty__c != null and HSFE_Sub_Specialty__c!= null]);// return  opportunity.
	}
	public void execute(Database.BatchableContext BC,List<sObject> scope){
		try{
			Map<String, Id> combKeytoTerrMap = new Map<String, Id>();
	        Set<Id> terrIdSet = new Set<Id>();
	        Boolean creatorPresent;
	        Id userId;
	        Set<ID> opptyID = new Set<ID>();
	        List<OpportunityTeamMember> teamToCreateList = new List<OpportunityTeamMember>();
	        List<Opportunity> updateOpp = new List<Opportunity>();
	        Set<String> combinationKeySet = new Set<String>();
	        OpportunityTeamMember tempTeam;
	        for(Sobject s : scope){
	        	Opportunity opp = (Opportunity)s;
	        	combinationKeySet.add(opp.HSFE_Combination_Key__c);
	        }
			List<HSFE_Account_Territory__c> accTerrList = new List<HSFE_Account_Territory__c>([SELECT Id, Account__c, Territory__c, HSFE_Combination_Key__c FROM HSFE_Account_Territory__c WHERE HSFE_Combination_Key__c IN :combinationKeySet]);
			for(HSFE_Account_Territory__c accTerr: accTerrList){
	        	combKeytoTerrMap.put(accTerr.HSFE_Combination_Key__c, accTerr.Territory__c);
	            terrIdSet.add(accTerr.Territory__c);
	        }
	        System.debug('*********************combKeytoTerrMap' + combKeytoTerrMap);
	        Map<String,HSFE_Territory_To_User__c> tempMap;
	        Map<Id, Map<String,HSFE_Territory_To_User__c >> territoryToRoleToUserMapMap = new Map<Id, Map<String,HSFE_Territory_To_User__c >>();
	        List<HSFE_Territory_To_User__c> terrToUserList= new List<HSFE_Territory_To_User__c>([Select Id, HSFE_User_Role__c,HSFE_Territory__c, HSFE_User__c from HSFE_Territory_To_User__c where HSFE_Territory__c IN :terrIdSet]);
	        for(HSFE_Territory_To_User__c terrUser: terrToUserList){
	            if(terrUser.HSFE_User_Role__c != null){
	                if(territoryToRoleToUserMapMap.containsKey(terrUser.HSFE_Territory__c)){
	                    tempMap = territoryToRoleToUserMapMap.get(terrUser.HSFE_Territory__c);
	                    tempMap.put(terrUser.HSFE_User_Role__c,terrUser);
	                }else{
	                    tempMap = new Map<String,HSFE_Territory_To_User__c>();
	                    tempMap.put(terrUser.HSFE_User_Role__c,terrUser);
	                }
	                territoryToRoleToUserMapMap.put(terrUser.HSFE_Territory__c,tempMap);
	            }
	        }
	        for(Sobject s : scope){
	        	Opportunity opp = (Opportunity)s;
	        	creatorPresent = false;
	            userId = opp.CreatedById;
	            opptyID.add(opp.id);
	            System.debug('*********************opp.HSFE_Combination_Key__c' + opp.HSFE_Combination_Key__c);
	            opp.HSFE_Territory__c = null;
	            if(combKeytoTerrMap.containsKey(opp.HSFE_Combination_Key__c)){
	                Id terrId = combKeytoTerrMap.get(opp.HSFE_Combination_Key__c);
	                opp.HSFE_Territory__c = terrId;
	                if(territoryToRoleToUserMapMap.containsKey(terrId)){
	                    tempMap = territoryToRoleToUserMapMap.get(terrId);
	                    System.debug('*********************tempMap' + tempMap);
	                    if(tempMap.containsKey(HSFE_Constant.TM)){
	                        opp.OwnerId = tempMap.get(HSFE_Constant.TM).HSFE_User__c;
	                    }
	                }
	                for(String role : tempMap.keySet()){
	                	if(userId == tempMap.get(role).HSFE_User__c){
	                		creatorPresent = true;
	                	}
	                    tempTeam = new OpportunityTeamMember(OpportunityId = opp.id, UserId = tempMap.get(role).HSFE_User__c, TeamMemberRole = role);
	                    teamToCreateList.add(tempTeam);
	                }
	                if(!creatorPresent){
	                	tempTeam = new OpportunityTeamMember(OpportunityId = opp.id, UserId = userId, TeamMemberRole = 'Creator');
	                    teamToCreateList.add(tempTeam);
	                }
	            }
	            updateOpp.add(opp);
	        	
	        }
	        List<Database.Saveresult> updateOptyResult = Database.update(updateOpp,false);
	        List<OpportunityTeamMember> teamToDeleteList = new List<OpportunityTeamMember>([SELECT Id from OpportunityTeamMember WHERE OpportunityId IN :opptyID AND OpportunityAccessLevel != 'All']);
	        List<Database.DeleteResult> deleteResult = Database.delete(teamToDeleteList, false); // Delete Opportunity Team members
	        List<Database.Saveresult> insertResult = Database.insert(teamToCreateList, false); //Insert Opoortunity Team members
	        List<OpportunityShare > updateOpptyShareList = new List<OpportunityShare>();
	        List<OpportunityShare > shares = [select Id, OpportunityAccessLevel, OpportunityId from OpportunityShare where OpportunityId IN :opptyID 
	                                         and OpportunityAccessLevel != 'All' and OpportunityAccessLevel !='Edit' and RowCause= 'Team'];
	        if(shares.size()>0){
	            for(OpportunityShare oppShare:shares ){
	                oppShare.OpportunityAccessLevel='Edit';
	                updateOpptyShareList.add(oppShare);
	            }
	        }
	        if(updateOpptyShareList.size()>0){
	            List<Database.Saveresult> updateResult = Database.update(updateOpptyShareList, false); //Update opportunity share table.
	        }
        }catch(Exception e){
          HSFE_ExceptionLogger.createExceptionLog(e);// Create a log file for an exception. 
        }
        
	}
	public void finish(Database.BatchableContext ctx){
		HSFE_ClearZipTempData_BatchClass clearZipObj = new HSFE_ClearZipTempData_BatchClass(); //This is used to delete records from temporary object.
    	database.executebatch(clearZipObj,200);//Excute a batch class.
    }
}