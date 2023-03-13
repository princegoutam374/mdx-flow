@isTest
public with sharing class FlowTest_JobRecordFlow {
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
        .doInsert()
        .account;
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MAYZENT - BA').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(acc.Id)
        .setRecordTypeId(recordTypeId)
        .setAppointmentServices('CBC')
        .doInsert()
        .cs;

        sked__Region__c region = new Data.RegionBuilder()
        .newRegion()
        .setTimeZone('Australia/Brisbane')
        .doInsert()
        .region;

    }
    /*
    * Type: Flow
    * Name: JobRecordFlow
    * Scenario: Whenever a job record is created
    */
    @isTest
    static void testNewJobScenario(){
        List<Case> cs = [Select Id from Case];
        List<sked__Region__c> region = [Select Id from sked__Region__c];
        try{
            sked__Job__c jb = new Data.JobBuilder()
            .newJob()
            .setDuration(10)
            .setRegion(region[0].Id)
            .setCase(cs[0].Id)
            .doInsert()
            .job;

            List<sked__Job_Tag__c> jobTag = [Select Id,sked__Job__c from sked__Job_Tag__c ];
            System.assertEquals(jb.Id, jobTag[0].sked__Job__c);
            
            List<sked__Job__c> res = [Select sked__Type__c from sked__Job__c where Id=: jb.Id];
            System.assertEquals('Injection Training', res[0].sked__Type__c);

            List<Case> updateCase = [Select Id, Phlebotomy__c from Case where Id=: cs[0].Id];
            System.assertEquals(true, updateCase[0].Phlebotomy__c);

            DateTime start  = System.now();
            DateTime finish = System.now().date()+1;
            List<sked__Job__c> jobList = [Select Id,sked__Start__c,sked__Finish__c,Notes__c,sked__Notes_Comments__c from sked__Job__c where Id=: jb.Id];
            jobList[0].Notes__c = 'Test Job';
            jobList[0].sked__Start__c = start;
            jobList[0].sked__Finish__c = finish;
            jobList[0].sked__Notes_Comments__c = 'Test Notes Comment';
            update jobList;   

            List<Case> caselist = [Select ID,Appointment_Date_Time__c,Notes__c from Case where Id =: cs[0].Id];
            List<sked__Job__c> jobRes = [Select Id,sked__Start__c,sked__Finish__c,Notes__c,sked__Notes_Comments__c from sked__Job__c where Id=: jobList[0].Id];
            System.assertEquals(jobRes[0].Notes__c, caselist[0].Notes__c);
            
        }catch(Exception ex){
            if(ex.getMessage().contains('INVALID_CROSS_REFERENCE_KEY')){
                System.debug('exception');
            }
        }
    }
}