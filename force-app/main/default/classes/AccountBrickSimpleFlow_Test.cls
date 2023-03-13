@isTest
public with sharing class AccountBrickSimpleFlow_Test {

    /*
    * Type: Flow
    * Name: Account (BrickSimple)
    * Node: AttestationDate
    * Scenario: AttestationDate is null, set Attestation Date to current date
    */
    @isTest
    static void positiveCase(){
        user u= [select id from user where Name = 'Brick Simple'][0];
        test.startTest();
        System.runAs(u){
             Account acc =  new Data.AccountBuilder()
            .newAccount()
            .newAccountPersonForTest()
            .setPersonmailingCountry('Canada')
            .setPersonMailingState('New Brunswick')
            .setHCPEmail('smith@gmail.com')
            .doInsert()
            .account;
        }
        test.stopTest();
        List<Account> resultAcc = [select id,PersonEmail,Program_Name__c,HCP_email__c,Attestation_Date__pc from account];
        system.debug([select id,PersonEmail,Program_Name__c,Attestation_Date__pc from account]);
        system.assertEquals(resultAcc[0].PersonEmail, resultAcc[0].HCP_email__c);
        system.assertEquals(resultAcc[0].Program_Name__c,'ZEPOSIA - UC');
        system.assertEquals(resultAcc[0].Attestation_Date__pc,system.today());


    }
    /*
    * Type: Flow
    * Name: Account (BrickSimple)
    * Node: AttestationDate
    * Scenario: AttestationDate is null, set Attestation Date to current date
    */
    @isTest
    static void negativeCase(){        
        test.startTest(); 
        Account acc =  new Data.AccountBuilder()
            .newAccount()
            .newAccountPersonForTest()
            .setPersonmailingCountry('Canada')
            .setPersonMailingState('New Brunswick')
            .setHCPEmail('smith@gmail.com')
            .doInsert()
            .account;
        test.stopTest();
        List<Account> resultAcc = [select id,PersonEmail,Program_Name__c,HCP_email__c,Attestation_Date__pc from account];
        system.debug([select id,PersonEmail,Program_Name__c,Attestation_Date__pc from account]);
        system.assertEquals(resultAcc[0].Program_Name__c==null, true);
        system.assertEquals(resultAcc[0].Attestation_Date__pc == null,true );
    


    }
}