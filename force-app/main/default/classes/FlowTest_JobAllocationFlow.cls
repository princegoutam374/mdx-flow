@isTest
public with sharing class FlowTest_JobAllocationFlow {
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

        sked__Resource__c resource = new Data.ResourceBuilder()
            .newResource()
            .setAccount(acc.Id)
            .doInsert()
            .resource;
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MAYZENT - BA').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
            .newCase()
            .setAccountId(acc.Id)
            .setRecordTypeId(recordTypeId)
            .setAssignedResource(resource.Id)
            .doInsert()
            .cs;

        sked__Region__c region = new Data.RegionBuilder()
            .newRegion()
            .setTimeZone('Australia/Brisbane')
            .doInsert()
            .region;
        
        sked__Job__c jb = new Data.JobBuilder()
            .newJob()
            .setDuration(10)
            .setRegion(region.Id)
            .setCase(cs.Id)
            .doInsert()
            .job;
    }
	
    /*
    * Type: Flow
    * Name: JobAllocationFlow
    * Scenario: Whenever a JobAllocationFlow record is created and sked__Status__c is Deleted, then Case Status will be Staff Provider
    */
    @isTest
    static void testProvider(){
        List<sked__Job__c> job = [Select Id, Case__c from sked__Job__c];
        List<sked__Resource__c> resource = [Select Id from sked__Resource__c];

        sked__Job_Allocation__c jobAllocation = new sked__Job_Allocation__c(
            sked__Job__c = job[0].Id,
            sked__UniqueKey__c = 'Unique13425',
            sked__Resource__c = resource[0].Id
        );

        insert jobAllocation;

        List<sked__Job_Allocation__c> jobAllocationList = [Select Id,sked__Status__c from sked__Job_Allocation__c];
        jobAllocationList[0].sked__Status__c = 'Deleted';
        update jobAllocationList;

        List<Case> caseRes = [Select Id, Status,Assigned_Clinician__c,Appointment_Confirmation_Status__c,Send_Go_Canvas_Forms_Immediately__c,
                                Reminder_Text_to_Patient__c,Reminder_Text_to_Clinician__c,Reminder_Email_to_Clinical_Staff__c,
                                Patient_Opt_out_Reminder_Call__c,Med_Kit_Requested__c,GoCanvas_Trigger__c,Confirm_Provider__c,Confirm_Patient__c,
                                Confirm_Clinician__c,Confirm_Clinician_Assets__c from Case where ID=: job[0].Case__c];
        System.assertEquals(null, caseRes[0].Assigned_Clinician__c);
        System.assertEquals('Staff Provider', caseRes[0].Status);
        System.assertEquals('Pending', caseRes[0].Appointment_Confirmation_Status__c);
        System.assertEquals(false, caseRes[0].Send_Go_Canvas_Forms_Immediately__c);
        System.assertEquals(false, caseRes[0].Reminder_Text_to_Patient__c);
        System.assertEquals(false, caseRes[0].Reminder_Text_to_Clinician__c);
        System.assertEquals(false, caseRes[0].Reminder_Email_to_Clinical_Staff__c);
        System.assertEquals(false, caseRes[0].Patient_Opt_out_Reminder_Call__c);
        System.assertEquals(false, caseRes[0].Med_Kit_Requested__c);
        System.assertEquals(false, caseRes[0].GoCanvas_Trigger__c);
        System.assertEquals(false, caseRes[0].Confirm_Provider__c);
        System.assertEquals(false, caseRes[0].Confirm_Patient__c);
        System.assertEquals(false, caseRes[0].Confirm_Clinician__c);
        System.assertEquals(false, caseRes[0].Confirm_Clinician_Assets__c);
    }

    /*
    * Type: Flow
    * Name: JobAllocationFlow
    * Scenario: Whenever a JobAllocationFlow record is created and sked__Status__c is Deleted and 
        Case Assigned Cinician is same as sked__Resource__c of Job Allocation record, then Case Status will be Staff Clinician
    */
    @isTest
    static void testClinician(){
        List<sked__Resource__c> resource = [Select Id from sked__Resource__c];
        List<Account> acc = [Select ID from Account];
        sked__Region__c region = [Select Id from sked__Region__c];

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MAYZENT - BA').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
            .newCase()
            .setAccountId(acc[0].Id)
            .setRecordTypeId(recordTypeId)
            .setAssignedClinician(resource[0].Id)
            .doInsert()
            .cs;
        
        sked__Job__c jb = new Data.JobBuilder()
            .newJob()
            .setDuration(10)
            .setRegion(region.Id)
            .setCase(cs.Id)
            .doInsert()
            .job;

        sked__Job_Allocation__c jobAllocation = new sked__Job_Allocation__c(
            sked__Job__c = jb.Id,
            sked__UniqueKey__c = 'Unique13425',
            sked__Resource__c = resource[0].Id
        );

        insert jobAllocation;

        List<sked__Job_Allocation__c> jobAllocationList = [Select Id,sked__Status__c from sked__Job_Allocation__c];
        jobAllocationList[0].sked__Status__c = 'Deleted';
        update jobAllocationList;

        List<Case> caseRes = [Select Id, Status,Assigned_Clinician__c from Case where ID=: jb.Case__c];
        System.assertEquals(null, caseRes[0].Assigned_Clinician__c);
        System.assertEquals('Staff Clinician', caseRes[0].Status);

    }
}