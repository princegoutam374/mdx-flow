@isTest
public class BMSAppointmentStatusReports_Test {
    @isTest //(SeeAllData=true)
    public static void flowTest(){
        
        
        //insert rt;
        
        //Id rtId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('ZEPOSIA_GASTRO').getRecordTypeId();
        
        
        
        
        //inserting Account record
        Account acc= new Account();
        acc.firstName= 'Dan';
        acc.LastName='Smith';
        acc.Personmailingcountry= 'Canada';
        acc.Personmailingstate = 'New Brunswick';
        acc.HCP_Email__c='smith@gmail.com';
        acc.PersonEmail='iamsps1995@gmail.com';
        
        insert acc;
        
        //inserting Case records
        // List<Case> caseList=new List<Case>();
        
        Case cs=new Case();
        Date newDate = Date.newInstance(2022, 12, 31);
        cs.RecordTypeId='0125w000000BXniAAG';
        cs.AccountId=acc.Id;
        cs.Status='Case Initiation';
        cs.Priority='Medium';
        cs.Preferred_Dates_Received_Date__c=newDate;
        cs.Confirm_Clinician__c=false;
        //cs.Staff_Confirmed_Date__c=newDate.addDays(2) ;
        cs.Appointment_Confirmation_Status__c='Send Confirmation Text';
        insert cs;
        list<case> updateList=new list<case>();
        For(Case cf:[select id ,Preferred_Date_1__c from Case where Id=:cs.Id]){
            Date neweDate = Date.newInstance(2022, 12, 31);
             cf.Preferred_Date_1__c=neweDate.addDays(5);
             updateList.add(cf);
        }
        update updateList;
         
        
        List<Case> c=[select id ,Preferred_Date_1__c,Preferred_Dates_Received_Date__c,Confirm_Clinician__c,Staff_Confirmed_Date__c,Appointment_Confirmation_Status__c from case where Id=:cs.Id];
        Case cet=[select id ,Preferred_Dates_Received_Date__c from case where Id=:cs.Id];
        //Validation
        System.assertEquals(System.today(),cet.Preferred_Dates_Received_Date__c);
        
       
        // DateTime nDate = DateTime.newInstance(2022, 12, 5);
        Datetime currentDateTime = Datetime.now();
        
        Datetime recordCreatedDate =  [SELECT  id ,CreatedDate FROM Case WHERE Id =:cs.Id].CreatedDate;
        
        Double timeDifference =currentDateTime.getTime() - recordCreatedDate.getTime();
        
        
        
        
    
        List<Case> caseList1=new List<Case>();
        for(Case cse:c){
            cse.Confirm_Clinician__c=true;
            caseList1.add(cse);
        }
        update caseList1;
        //Validation
        Case ces= [select id ,Staff_Confirmed_Date__c from Case where id=:cs.Id ];
        System.assertEquals(System.today(), ces.Staff_Confirmed_Date__c);
        
        
        /*List<Case> caseList2=new List<Case>();

for(Case ce:c){
ce.Staff_Confirmed_Date__c=System.today(); 
caseList2.add(ce);
}
update caseList2;*/
        
        
        List<Case> caseList3=new List<Case>();
        
        for(Case cr:c){
            cr.Appointment_Confirmation_Status__c='Confirmed'; 
            caseList3.add(cr);
        }
        update caseList3; 
        Case cer=[select id , Appointment_Status_Lash__c,Patient_and_Staff_Confirmed_Date__c from case where id=:cs.Id];
        //Validation
        System.assertEquals('Appointment Changed', cer.Appointment_Status_Lash__c);
        System.assertEquals(System.today(), cer.Patient_and_Staff_Confirmed_Date__c);
        
    }
}