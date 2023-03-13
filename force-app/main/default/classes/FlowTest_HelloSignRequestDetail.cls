@isTest
public class FlowTest_HelloSignRequestDetail {
	@TestSetup
    static void createData(){
        Account acc =  new Data.AccountBuilder()
        .newAccount()
        .newAccountPersonForTest()
        .setPersonmailingCountry('Canada')
        .setPersonMailingCity('New Brunswick')
        .setPersonMailingState('New Brunswick')
        .setPersonMailingStreet('New Brunswick')
        .setMailingStreet1('4206 Minnesota')
        .setMailingStreet2('Pine Apt. 165')
        .setConsentToText('Yes')
        .setFax('21212121')
        .setOfficeContactEmail('abc@test.com')
        .setOfficeContactName('Test Office Contact')
        .setSMSOptOut(false)
        .doInsert()
        .account;

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(acc.Id)
        .setRecordTypeId(recordTypeId)
        .setPatientSMSOptOut(false)
        .doInsert()
        .cs;
    }
    
    /*
    * Type: Flow
    * Name: HelloSignRequestDetail
    * Node: Event
    * Scenario: Event set to Signed, Case Status should set to Assign Asset
    */
    @isTest
    static void testSigned(){
        List<Case> cs = [Select Id from Case limit 1];
        HelloSign__HelloSign_Signature_Request__c sigReq = new HelloSign__HelloSign_Signature_Request__c(
            Case__c = cs[0].Id,
            HelloSign__Document_Name__c = 'Test Doc'
        );
        insert sigReq;
        HelloSign__HelloSign_Signature_Request_Detail__c sig = new HelloSign__HelloSign_Signature_Request_Detail__c(
            HelloSign__Event__c = 'Signed',
            HelloSign__HelloSign_Signature_Request__c = sigReq.Id
        );
        insert sig;
        
        List<Case> res = [Select ID, status from Case where Id =: cs[0].id];
        System.assertEquals('Assign Asset', res[0].Status);
    }
    
    /*
    * Type: Flow
    * Name: HelloSignRequestDetail
    * Node: Event
    * Scenario: Event set to Send, Case Attestation_Sent_Date__c should set to Signature request detail hello sign date
    */
    @isTest
    static void testSent(){
        List<Case> cs = [Select Id from Case limit 1];
        HelloSign__HelloSign_Signature_Request__c sigReq = new HelloSign__HelloSign_Signature_Request__c(
            Case__c = cs[0].Id,
            HelloSign__Document_Name__c = 'Test Doc'
        );
        insert sigReq;
        HelloSign__HelloSign_Signature_Request_Detail__c sig = new HelloSign__HelloSign_Signature_Request_Detail__c(
            HelloSign__Event__c = 'Sent',
            HelloSign__HelloSign_Signature_Request__c = sigReq.Id,
            HelloSign__Date__c  = System.today()
        );
        insert sig;
        
        List<Case> res = [Select ID, Attestation_Sent_Date__c from Case where Id =: cs[0].id];
        System.assertEquals(sig.HelloSign__Date__c, res[0].Attestation_Sent_Date__c+1);
    }
}