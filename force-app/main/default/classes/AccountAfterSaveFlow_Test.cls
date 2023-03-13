@istest
public with sharing class AccountAfterSaveFlow_Test {
    @TestSetup
    static void createAccount(){
       Account acc =  new Data.AccountBuilder()
        .newAccount()
        .newAccountPersonForTest()
        .setPersonmailingCountry('Canada')
        .setPersonMailingCity('New Brunswick')
        .setPersonMailingState('New Brunswick')
        .setPersonMailingStreet('New Brunswick')
        .doInsert()
        .account;
        
    }

    /*
    * Type: FLow
    * Name: Account After Save Flow
    * Node:  Last Name Updated
    * Scenario: Last Name updated to UNKNOWN, revert the last to prior value
    */
    @isTest
    static void positiveCase(){
        
        list<Account> accList = new List<Account>();
        accList = [select id,lastname from Account];
        string lastname=accList[0].lastName;
        accList[0].LastName = 'UNKNOWN';
        test.startTest();
        update accList;
        test.stopTest();
        system.assertEquals([select Lastname from account][0].lastName,lastName );
        
    }

    /*
    * Type: Flow
    * Name: Account After Save Flow
    * Node:  Last Name Updated
    * Scenario: Last Name not updated to UNKNOWN, set the last to current value
    */
    @isTest
    static void negativeCase(){
        list<Account> accList = new List<Account>();
        accList = [select id,lastname from Account];
        accList[0].LastName = 'Lee';
        test.startTest();
        update accList;
        test.stopTest();
        system.assertEquals([select Lastname from account][0].lastName,'Lee' );
        
    }
}