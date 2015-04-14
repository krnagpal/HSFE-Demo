trigger HSFE_LineItem_TriggerHandler on Apttus_Config2__LineItem__c (before insert) {
	System.debug('@@@ Inside Apttus Line Item');
    Testing_HTTP_Callout_LineItem.getOrganisationInfo('167.219.48.10');
    for(Apttus_Config2__LineItem__c objVar : Trigger.new){
        objVar.HSFE_Contract_Price__c = 400;
        System.debug('@@@ Setting Contract Price Value as : 400');
    }
    System.debug('After HTTP Callout');
}