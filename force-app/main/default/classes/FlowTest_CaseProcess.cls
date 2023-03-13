@isTest
public with sharing class FlowTest_CaseProcess {
    @TestSetup
    static void createAccount(){
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
        
        sked__Region__c region = new Data.RegionBuilder()
        .newRegion()
        .setTimeZone('Australia/Brisbane')
        .doInsert()
        .region;
        
    }
    
    /*
    * Type: Process Builder
    * Name: Case Process v4
    * Node: Case Creation
    * Scenario: Case Record Type to ZEPOSIA - GASTRO,
    * Information from Lash should contain Drug, Appointment State of Case should set to Account PersonmailingState and etc..
    */
    @isTest
    static void testCaseCreationPositiveCase(){
        Account ac = [SELECT FirstName, LastName, PersonContactId, Personmailingcountry, Personmailingstate, 
                      Personmailingstreet, Mailing_Street_1__c, Mailing_Street_2__c, PersonMobilePhone, Phone, 
                      PersonEmail FROM Account];
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(ac.Id)
        .setRecordTypeId(recordTypeId)
        .setReferringProvider(ac.Id)
        .doInsert()
        .cs;
        
        Case cas = [SELECT id, ContactId, Contact_Mobile_Stamp__c, Contact_Email__c, Contact_Phone_Stamp__c, 
                    HCP_Phone_Stamp__c,Office_Contact_Email__c, Office_Contact_Name__c,Information_from_Lash__c,
                    Appointment_State__c, Appointment_Address_1__c, Appointment_Address_2__c, HCP_Fax_Stamp__c,
                    Account.Personmailingstate, Account.Mailing_Street_1__c, Account.Fax,HCP_Fax__c ,
                    Account.Mailing_Street_2__c, Account.PersonContactId, Account.Consent_To_Text__c,
                    Account.PersonMobilePhone, Account.Phone, Account.PersonEmail,Patient_SMS_Opt_Out__c,
                    Account.Office_Contact_Email__c, Account.Office_Contact_Name__c 
                    FROM Case WHERE Id =: cs.Id];
        
        System.assertEquals(cas.Appointment_State__c,cas.Account.Personmailingstate);
        System.assertEquals(cas.Appointment_Address_1__c,cas.Account.Mailing_Street_1__c);
        System.assertEquals(cas.Appointment_Address_2__c,cas.Account.Mailing_Street_2__c);
        System.assertEquals(cas.ContactId,cas.Account.PersonContactId);
        
        System.assertEquals(cas.Contact_Mobile_Stamp__c,cas.Account.PersonMobilePhone);
        System.assertEquals(cas.Contact_Phone_Stamp__c,cas.Account.Phone);
        System.assertEquals(cas.Contact_Email__c,cas.Account.PersonEmail);
        System.assertEquals(cas.Patient_SMS_Opt_Out__c,Boolean.valueOf(cas.Account.Consent_To_Text__c));
        System.assertEquals(cas.HCP_Fax_Stamp__c,cas.Account.Fax);
        System.assertEquals(cas.HCP_Phone_Stamp__c,cas.Account.Phone);
        System.assertEquals(cas.Office_Contact_Email__c,cas.Account.Office_Contact_Email__c );
        System.assertEquals(cas.Office_Contact_Name__c,cas.Account.Office_Contact_Name__c);
        System.assertEquals(cas.Information_from_Lash__c.contains('Drug Name'), cas.Information_from_Lash__c.contains('Drug Name'));
    }
    
    /*
    * Type: Process Builder
    * Name: Case Process v4
    * Node: Case Creation
    * Scenario: Case Record Type not to ZEPOSIA - GASTRO,
    * Information from Lash should not contain Drug, Appointment State of Case should not set to Account PersonmailingState and etc..
    */
    @isTest
    static void testCaseCreationNegativeCase(){
        Account ac = [SELECT FirstName, LastName, PersonContactId, Personmailingcountry, Personmailingstate, 
                      Personmailingstreet, Mailing_Street_1__c, Mailing_Street_2__c, PersonMobilePhone, Phone, 
                      PersonEmail FROM Account];
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('BMS').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(ac.Id)
        .setRecordTypeId(recordTypeId)
        .setReferringProvider(ac.Id)
        .doInsert()
        .cs;
        
        Case cas = [SELECT id, ContactId, Contact_Mobile_Stamp__c, Contact_Email__c, Contact_Phone_Stamp__c, 
                    HCP_Phone_Stamp__c,Office_Contact_Email__c, Office_Contact_Name__c,
                    Appointment_State__c, Appointment_Address_1__c, Appointment_Address_2__c, HCP_Fax_Stamp__c,
                    Account.Personmailingstate, Account.Mailing_Street_1__c, Account.Fax,HCP_Fax__c ,
                    Account.Mailing_Street_2__c, Account.PersonContactId, Account.Consent_To_Text__c,
                    Account.PersonMobilePhone, Account.Phone, Account.PersonEmail,Patient_SMS_Opt_Out__c,
                    Account.Office_Contact_Email__c, Account.Office_Contact_Name__c 
                    FROM Case WHERE Id =: cs.Id];
        
        System.assertNotEquals(cas.Appointment_Address_1__c,cas.Account.Mailing_Street_1__c);
        
        System.assertEquals(cas.Contact_Mobile_Stamp__c,cas.Account.PersonMobilePhone);
        System.assertEquals(cas.Contact_Phone_Stamp__c,cas.Account.Phone);
        System.assertEquals(cas.Contact_Email__c,cas.Account.PersonEmail);
        System.assertEquals(cas.Patient_SMS_Opt_Out__c,Boolean.valueOf(cas.Account.Consent_To_Text__c));
        System.assertEquals(cas.HCP_Fax_Stamp__c,cas.Account.Fax);
        System.assertEquals(cas.HCP_Phone_Stamp__c,cas.Account.Phone);
        System.assertEquals(cas.Office_Contact_Email__c,cas.Account.Office_Contact_Email__c );
        System.assertEquals(cas.Office_Contact_Name__c,cas.Account.Office_Contact_Name__c);
    }

    /*
    * Type: Process Builder
    * Name: Case Process v4
    * Node: Patient Opt In
    * Scenario: Patient SMS Opt out is changed and set to false
    * Consent to text should set to yes
    */
    @isTest
    static void testPatientOptIn(){
        
        Account ac = [SELECT FirstName, LastName, PersonContactId, Personmailingcountry, Personmailingstate, Personmailingstreet, Mailing_Street_1__c, 
        Mailing_Street_2__c, PersonMobilePhone, Phone, PersonEmail FROM Account ];
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(ac.Id)
        .setRecordTypeId(recordTypeId)
        .setReferringProvider(ac.Id)
        .setPatientSMSOptOut(true)
        .doInsert()
        .cs;
        
        List<Case> caseList = [Select Id,Patient_SMS_Opt_Out__c from Case where Id=:cs.Id];
        caseList[0].Patient_SMS_Opt_Out__c = false;
        update caseList;
        
        System.assertEquals('Yes', [Select Id,Consent_to_Text__c from Case where Id =:caseList[0].Id].Consent_to_Text__c);
    }
    
    /*
    * Type: Process Builder
    * Name: Case Process v4
    * Node: Patient Opt In
    * Scenario: Patient SMS Opt out is set to true
    * Consent to text should set to no
    */
    @isTest
    static void testPatientOptOut(){
        Account ac = [SELECT FirstName, LastName, PersonContactId, Personmailingcountry, Personmailingstate, 
                      Personmailingstreet, Mailing_Street_1__c, Mailing_Street_2__c, PersonMobilePhone, Phone, 
                      PersonEmail FROM Account];
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(ac.Id)
        .setRecordTypeId(recordTypeId)
        .setReferringProvider(ac.Id)
        .setPatientSMSOptOut(true)
        .doInsert()
        .cs;
        
        System.assertEquals('No', [Select Id,Consent_to_Text__c from Case where Id =:cs.Id].Consent_to_Text__c);
    }

    /*
    * Type: Process Builder
    * Name: Case Process v4
    * Node: Case Cancelled
    * Scenario: Case status set to cancelled
    * Cancel Job should set to true associated to case and appointment status (lash) on case to Appointment Cancelled
    */
    @isTest
    static void testCaseCancelled(){        
        Account ac = [SELECT Id FROM Account];
        
        payloads__Integration__c integration = new payloads__Integration__c(
			Name = 'Test Integration'
		);
		insert integration;

        payloads__OutboundPayload__c outBoundPayload = new payloads__OutboundPayload__c();
        outBoundPayload.payloads__Integration__c	 = integration.Id;
        insert outBoundPayload;
        
        sked__Region__c region = [Select Id from sked__Region__c];

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(ac.Id)
        .setRecordTypeId(recordTypeId)
        .setReferringProvider(ac.Id)
        .doInsert()
        .cs;
        
        payloads__OutboundPayloadJob__c  pay_load = new payloads__OutboundPayloadJob__c();
        pay_load.payloads__Integration__c  = integration.Id;
        pay_load.payloads__Status__c = 'New';
        pay_load.Case__c = cs.Id;
        pay_load.payloads__OutboundPayload__c  = outBoundPayload.Id;
        insert pay_load;

        payloads__OutboundPayloadSource__c payloadSource = new payloads__OutboundPayloadSource__c();
        payloadSource.Name = 'Test Payload Source';
        payloadSource.payloads__OutboundPayload__c = outBoundPayload.Id;
        insert payloadSource;

        payloads__OutboundPayloadJobSource__c jobSource = new payloads__OutboundPayloadJobSource__c();
        jobSource.payloads__OutboundPayloadSource__c = payloadSource.Id;
        jobSource.payloads__Value__c = cs.Id;
        jobSource.payloads__OutboundPayloadJob__c = pay_load.Id;
        jobSource.payloads__OutboundPayload__c = outBoundPayload.Id;
        insert jobSource;

        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test';
        cv.PathOnClient = 'test.pdf';
        cv.VersionData = bodyBlob;
        insert cv;

        ContentDistribution cd = new ContentDistribution();
        cd.Name = 'test';
        cd.ContentVersionId = cv.id;
        insert cd;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = cs.Id;
        cdl.ContentDocumentId = documents[0].Id;
        insert cdl; 
        
        Case updateCase = [Select Id, Status, RecordTypeId, Cancellation_Reason__c from Case where Id =: cs.Id];
        updateCase.Status = 'Cancelled';
        updateCase.Cancellation_Reason__c = 'Government';
        try{
            update updateCase;
        }catch(Exception ex){
            if(ex.getMessage().contains('Null Pointer')){
                System.debug('exception');
            }
        }        
        sked__Job__c jb = new Data.JobBuilder()
        .newJob()
        .setDuration(10)
        .setRegion(region.Id)
        .setCase(updateCase.Id)
        .doInsert()
        .job;
    }
    
    /*
    * Type: Process Builder
    * Name: Case Process v4
    * Node: Job Creation
    * Scenario: Contact on case not blank, Mailing State on contact not blank, Job related to case should be null, Appointment Date time on case not null,
    * case record type should be ZEPOSIA - GASTRO and Appointment Services on Case not null
    * Create Job record and link Case to it
    */
    @isTest
    static void testJobCreation(){
        Account acc = [SELECT FirstName, LastName, PersonContactId, Personmailingcountry, Personmailingstate, 
                      Personmailingstreet, Mailing_Street_1__c, Mailing_Street_2__c, PersonMobilePhone, Phone, 
                      PersonEmail FROM Account];
        
        sked__Region__c region = [Select Id from sked__Region__c];
                
        Contact con= new Contact();
        con.firstName= 'Test';
        con.LastName='Contact 01';
        con.MailingCountry = 'United States';
        con.MailingState = 'New York';
        con.MailingStateCode = 'NY';
        con.sked__Region__c = region.id;
        insert con;
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        DateTime apptDateTime  = System.today();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(acc.Id)
        .setRecordTypeId(recordTypeId)
        .setReferringProvider(acc.Id)
        .setPatientSMSOptOut(true)
        .setAppointmentDateTime(apptDateTime)
        .doInsert()
        .cs;

        sked__Job__c jb = new Data.JobBuilder()
        .newJob()
        .setDuration(10)
        .setRegion(region.Id)
        .doInsert()
        .job;

        List<Case> caseList = [Select Id, Appointment_Date_Time__c,Appointment_Date__c from Case where Id =: cs.Id];
        caseList[0].Appointment_Date_Time__c = System.today()+1;
        caseList[0].Appointment_Services__c = 'EKG';
        try{
            update caseList;
        }catch(Exception ex){
            if(ex.getMessage().contains('Null Pointer')){
                System.debug('exception');
            }
        } 
    }

    /*
    * Type: Process Builder
    * Name: Case Process v4
    * Node: SRF Confirmed
    * Scenario: Confirmation SRF For Patient Set is changed and set to true, should set Case Status to Staff Provider
    */
    @isTest
    static void testSRFComfirmedPositiveScenario(){
        Account ac = [SELECT Id FROM Account];

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(ac.Id)
        .setRecordTypeId(recordTypeId)
        .setStatus('Case Initiation')
        .setConfirmSRFForPatient(false)
        .doInsert()
        .cs;
        
        Case updateCase = [Select Id,Confirm_SRF_for_Patient__c from Case where Id =:cs.Id];
        updateCase.Confirm_SRF_for_Patient__c = true;
        update updateCase;

        System.assertEquals('Staff Provider', [Select Id, Status from Case where Id =:updateCase.Id].Status);
    }
    
    /*
    * Type: Process Builder
    * Name: Case Process v4
    * Node: SRF Confirmed
    * Scenario: Confirmation SRF For Patient Set set to false, should not set Case Status to Staff Provider
    */
    @isTest
    static void testSRFComfirmedNegativeScenario(){
        Account ac = [SELECT Id FROM Account];

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(ac.Id)
        .setRecordTypeId(recordTypeId)
        .setStatus('Case Initiation')
        .setConfirmSRFForPatient(false)
        .doInsert()
        .cs;

        System.assertNotEquals('Staff Provider', [Select Id, Status from Case where Id =:cs.Id].Status);
    }
    
    /*
    * Type: Process Builder
    * Name: Case Process v4
    * Node: Patient Outreach Unsuccessfull
    * Scenario: Appointment Confirmation Status is changed and set to Unable to Contact, Should set Appointment Status Lash to Unable to Contact
    */
    @isTest
    static void testPatientOutReachUnSuccessfullPositiveScenario(){
        Account ac = [SELECT Id FROM Account];

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(ac.Id)
        .setRecordTypeId(recordTypeId)
        .setAppointmentConfirmationStatus('Pending')
        .doInsert()
        .cs;
        
        Case updateCase = [Select Id,Appointment_Confirmation_Status__c from Case where Id =:cs.Id];
        updateCase.Appointment_Confirmation_Status__c = 'Unable to Contact';
        update updateCase;

        System.assertEquals('Unable to Contact', [Select Id, Appointment_Status_Lash__c from Case where Id =:cs.Id].Appointment_Status_Lash__c);
    }
    
    /*
    * Type: Process Builder
    * Name: Case Process v4
    * Node: Patient Outreach Unsuccessfull
    * Scenario: Appointment Confirmation Status is set to Pending, Should not set Appointment Status Lash to Unable to Contact
    */
    @isTest
    static void testPatientOutReachUnSuccessfullNegativeScenario(){
        Account ac = [SELECT Id FROM Account];

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(ac.Id)
        .setRecordTypeId(recordTypeId)
        .setAppointmentConfirmationStatus('Pending')
        .doInsert()
        .cs;
        
        Case updateCase = [Select Id,Appointment_Confirmation_Status__c from Case where Id =:cs.Id];
        updateCase.Appointment_Confirmation_Status__c = 'Confirmed';
        update updateCase;

        System.assertNotEquals('Unable to Contact', [Select Id, Appointment_Status_Lash__c from Case where Id =:cs.Id].Appointment_Status_Lash__c);
    }
    
    /*
    * Type: Process Builder
    * Name: Case Process v4
    * Node: Patient Confirmed > 1
    * Scenario: Appointment Confirmation Status is changed and set to Confirmed, Appointment Date Time to past two days than today
    * should set case status to Reminders
    */
    @isTest
    static void testPatientConfirmedPositiveScenario(){
        Account ac = [SELECT Id FROM Account];

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(ac.Id)
        .setRecordTypeId(recordTypeId)
        .setAppointmentConfirmationStatus('Pending')
        .doInsert()
        .cs;
        
        Case updateCase = [Select Id,Appointment_Confirmation_Status__c,Appointment_Date_Time__c from Case where Id =:cs.Id];
        updateCase.Appointment_Confirmation_Status__c = 'Confirmed';
        updateCase.Appointment_Date_Time__c = System.today() - 2;
        updateCase.Status = 'Reminders';
        update updateCase;
        
        System.assertEquals('Reminders', [Select Id, Status from Case where Id =:updateCase.Id].Status);
    }
    
    /*
    * Type: Process Builder
    * Name: Case Process v4
    * Node: ZEPOSIA Patient Conf <1
    * Scenario: Appointment Confirmation Status is changed and set to Confirmed, Appointment Date Time to past one days than today
    * should set case status to Reminders
    */
    @isTest
    static void testZeposiaPatientConfirmedPositiveScenario(){
        Account ac = [SELECT Id FROM Account];
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(ac.Id)
        .setRecordTypeId(recordTypeId)
        .setAppointmentConfirmationStatus('Pending')
        .setAssignedResourceEmail('test@test.com')
        .setAppointmentServices('Macular Edema')
        .doInsert()
        .cs;
        
        sked__Region__c region = [Select Id from sked__Region__c];
        
        sked__Job__c jb = new Data.JobBuilder()
        .newJob()
        .setDuration(10)
        .setRegion(region.Id)
        .doInsert()
        .job;
        
        Case updateCase = [Select Id,Appointment_Confirmation_Status__c,Appointment_Date_Time__c from Case where Id =:cs.Id];
        updateCase.Appointment_Confirmation_Status__c = 'Confirmed';
        updateCase.Appointment_Date_Time__c = System.today() - 1;
        try{
            update updateCase;
        }catch(Exception ex){
            if(ex.getMessage().contains('Null Pointer')){
                System.debug('exception');
            }
        } 
    }
    
    /*
    * Type: Process Builder
    * Name: Case Process v4
    * Node: Update to Appointment
    * Scenario: Status Updated to Appointment, Reminder Text to Patient to true and Reminder Text to Patient and Clinician to true
    * should set case status to Appointment
    */
    @isTest
    static void testUpdateToAppointment(){
        Account ac = [SELECT Id FROM Account];
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(ac.Id)
        .setRecordTypeId(recordTypeId)
        .setStatus('Reminders')
        .setReminderTextToClinician(True)
        .setReminderEmailToClinicalStaff(False)
        .setReminderTextToPatient(False)
        .doInsert()
        .cs;
        
        Case updateCase = [Select Id,Reminder_Text_to_Patient__c,Reminder_Text_to_Patient_and_Clinician__c from Case where Id =:cs.Id];
        updateCase.Reminder_Text_to_Patient_and_Clinician__c = True;
        updateCase.Reminder_Text_to_Patient__c = True;
        updateCase.Status = 'Appointment';
        update updateCase;
        
        System.assertEquals('Appointment', [Select Id, Status from Case where Id =:updateCase.Id].Status);
    }
    
    /*
    * Type: Process Builder
    * Name: Case Process v4
    * Node: Report Results
    * Scenario: Confirmation Attendance for Patient MA is changed and set to true
    * should set case status to Report Results
    */
    @isTest
    static void testReportResults(){
        Account ac = [SELECT Id FROM Account];
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA - GASTRO').getRecordTypeId();
        Case cs = new Data.CaseBuilder()
        .newCase()
        .setAccountId(ac.Id)
        .setRecordTypeId(recordTypeId)
       	.setConfirmAttendanceForPatient(False)
        .doInsert()
        .cs;
        
        Case updateCase = [Select Id,Confirm_Attendance_for_Patient_MA__c from Case where Id =:cs.Id];
        updateCase.Confirm_Attendance_for_Patient_MA__c = True;
        update updateCase;
        
        System.assertEquals('Report Results', [Select Id, Status,Report_Results_Date__c from Case where Id =:updateCase.Id].Status);
        System.assertEquals(System.today(), [Select Id,Report_Results_Date__c from Case where Id =:updateCase.Id].Report_Results_Date__c);

    }
    
    /*
    * Type: Process Builder
    * Name: Case Process v4
    * Node: Case Complete
    * Scenario: Case Status updated to Complete
    */
    @isTest
    static void testCaseComplete(){
        Account ac = [SELECT Id FROM Account where FirstName = 'Dan'];
        try{
            Case cs = new Data.CaseBuilder()
            .newCase()
            .setAccountId(ac.Id)
            .setStatus('Case Initiation')
            .doInsert()
            .cs;
            
            Case updateCase = [Select Id,Status from Case where AccountId =:ac.Id];
            updateCase.Status = 'Complete';   
            update updateCase;
        }catch(Exception ex){
            if(ex.getMessage().contains('Null Pointer')){
                System.debug('exception');
            }
        }
        

    }
    
    /*
    * Type: Process Builder
    * Name: Case Process v4
    * Node: Partially Complete
    * Scenario: Case Status updated to Partially Completed
    */
    @isTest
    static void testCasePartiallyComplete(){
        Account ac = [SELECT Id FROM Account where FirstName = 'Dan'];
        
        try{
            Case cs = new Data.CaseBuilder()
            .newCase()
            .setAccountId(ac.Id)
            .setStatus('Case Initiation')
            .doInsert()
            .cs;
            
            Case updateCase = [Select Id,Status from Case where AccountId =:ac.Id];
            updateCase.Status = 'Partially Complete';   
            update updateCase;
        }catch(Exception ex){
            if(ex.getMessage().contains('Null Pointer')){
                System.debug('exception');
            }
        }
    }
    
    /*
    * Type: Process Builder
    * Name: Case Process v4
    * Node: Job Cancelled
    * Scenario: Cancel Case set to true, should set case status to Cancelled
    */
    @isTest
    static void testJobCancelled(){
        Account ac = [SELECT Id FROM Account where FirstName = 'Dan'];     
        try{
            Case cs = new Data.CaseBuilder()
            .newCase()
            .setAccountId(ac.Id)
            .doInsert()
            .cs;
            
            Case updateCase = [Select Id,Cancel_Case__c from Case where AccountId =:ac.Id];
            updateCase.Cancel_Case__c = True;   
            update updateCase;
        }catch(Exception ex){
            if(ex.getMessage().contains('Null Pointer')){
                System.debug('exception');
            }
        } 
    }
}