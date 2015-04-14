trigger HSFE_Proposal_LineItem_TriggerHandler on Apttus_Proposal__Proposal_Line_Item__c (before insert) {
	System.debug('@@@ Inside Apttus Proposal Line Item');
}