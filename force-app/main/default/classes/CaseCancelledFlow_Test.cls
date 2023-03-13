@isTest
public class CaseCancelledFlow_Test {
    @isTest
    public static void positiveCase(){
        //inserting Account record
        Account acc= new Account();
        acc.firstName= 'Dan';
        acc.LastName='Smith';
        acc.Personmailingcountry= 'Canada';
        acc.Personmailingstate = 'New Brunswick';
        acc.HCP_Email__c='smith@gmail.com';
        
        insert acc;
 
        
        //inserting Case records
        List<Case> caseList=new List<Case>();
        Case cs=new Case();
        cs.recordtypeid='0125w000000BXndAAG';
        cs.AccountId=acc.Id;
        cs.Status='Case Initiation';
        cs.Priority='Medium';
        //cs.Confirm_Clinician__c=false;
        //cs.Staff_Confirmed_Date__c=newDate.addDays(2) ;
       // cs.Appointment_Confirmation_Status__c='Send Confirmation Text';
       
        
   
        insert cs;
       
        
        //inserting region records
        sked__Region__c r=new sked__Region__c();
        r.Name='South India';
        r.sked__Timezone__c='Australia/Brisbane';
        
        insert r;
        
        //inserting new Job Records
        sked__Job__c wj=new sked__Job__c();
        wj.Case__c=cs.Id;
        wj.sked__Job_Status__c='Queued';
        wj.sked__Region__c=r.Id;
        wj.sked__Duration__c=345;
        
        insert wj;
        
        
         
        List<Case> cList=[select id ,status from Case where Id=:cs.Id];
        
        for(Case c:cList){
            c.Status='closed';
            c.Status='Cancelled';
            c.Cancellation_Reason__c='Government';
            caseList.add(c);
            
        }
        if(!caseList.isEmpty()){
            test.startTest();
            update caseList;
            test.stopTest();
        }
        List<sked__Job__c> jobList =[select id , name ,sked__Job_Status__c from sked__Job__c where Case__c=:cs.Id];
        
        System.assertEquals('Cancelled', jobList[0].sked__Job_Status__c);
    }
}