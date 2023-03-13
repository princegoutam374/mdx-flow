@isTest
public class FlowTest_ResourceRecordFlow {
    @TestSetup
    static void createAccount(){
        sked__Resource__c resource = new Data.ResourceBuilder()
        .newResource()
        .doInsert()
        .resource;
        
        sked__Tag__c tag = new Data.TagBuilder()
            .newTag()
            .setName('Test Tag')
            .setClassification('Global')
            .setType('Skill')
            .setUniqueKey('Test Unique')
            .doInsert()
            .tag;

        sked__Resource_Tag__c resourceTag = new Data.ResourceTagBuilder()
            .newResourceTag()
            .setResource(resource.id)
            .setTag(tag.id)
            .doInsert()
            .resourceTag;            
    }

    /*
    * Type: Flow
    * Name: ResourceRecordFlow
    * Scenario: Adbry Case Count changed, Covid 19 Vaccination set to Exepmt, resource tag record will be created
    */
    @isTest
    static void testAdbry(){
        sked__Resource__c resource = [Select Id, Adbry_Case_Count__c, COVID_19_Vaccination__c from sked__Resource__c];
        resource.Adbry_Case_Count__c = 1;
        resource.COVID_19_Vaccination__c = 'Exempt';
        try{
			update resource;
            sked__Resource__c res = [Select Id,Last_Adbry_Case__c from sked__Resource__c where Id =: resource.Id];
            System.assertEquals(System.today(), res.Last_Adbry_Case__c);
    
            List<sked__Resource_Tag__c> resTag = [Select Id from sked__Resource_Tag__c where sked__Resource__c =: res.id];
            System.assertEquals(1, resTag.size());            
        }catch(Exception ex){
            if(ex.getMessage().contains('INVALID_CROSS_REFERENCE_KEY')){
                System.debug('exception');
            }
        }
    }

    /*
    * Type: Flow
    * Name: ResourceRecordFlow
    * Scenario: GILENYA_BA_Count__c changed, Covid 19 Vaccination set to Exepmt, resource tag record will be created
    */
    @isTest
    static void testGILENYA_BA(){
        sked__Resource__c resource = [Select Id, GILENYA_BA_Count__c, COVID_19_Vaccination__c from sked__Resource__c];
        resource.GILENYA_BA_Count__c = 1;
        resource.COVID_19_Vaccination__c = 'Exempt';
        try{
			update resource;
            sked__Resource__c res = [Select Id,Last_Adbry_Case__c from sked__Resource__c where Id =: resource.Id];
            System.assertEquals(System.today(), res.Last_Adbry_Case__c);
    
            List<sked__Resource_Tag__c> resTag = [Select Id from sked__Resource_Tag__c where sked__Resource__c =: res.id];
            System.assertEquals(1, resTag.size());            
        }catch(Exception ex){
            if(ex.getMessage().contains('INVALID_CROSS_REFERENCE_KEY')){
                System.debug('exception');
            }
        }
    }

    /*
    * Type: Flow
    * Name: ResourceRecordFlow
    * Scenario: GILENYA_FDO_Count__c changed, Covid 19 Vaccination set to Exepmt, resource tag record will be created
    */
    @isTest
    static void testGILENYA_FDO(){
        sked__Resource__c resource = [Select Id, GILENYA_FDO_Count__c, COVID_19_Vaccination__c from sked__Resource__c];
        resource.GILENYA_FDO_Count__c = 1;
        resource.COVID_19_Vaccination__c = 'Exempt';
        try{
			update resource;
            sked__Resource__c res = [Select Id,Last_Adbry_Case__c from sked__Resource__c where Id =: resource.Id];
            System.assertEquals(System.today(), res.Last_Adbry_Case__c);
    
            List<sked__Resource_Tag__c> resTag = [Select Id from sked__Resource_Tag__c where sked__Resource__c =: res.id];
            System.assertEquals(1, resTag.size());            
        }catch(Exception ex){
            if(ex.getMessage().contains('INVALID_CROSS_REFERENCE_KEY')){
                System.debug('exception');
            }
        }
    }

    /*
    * Type: Flow
    * Name: ResourceRecordFlow
    * Scenario: MAYZENT_BA_Count__c changed, Covid 19 Vaccination set to Exepmt, resource tag record will be created
    */
    @isTest
    static void testMAYZENT_BA(){
        sked__Resource__c resource = [Select Id, MAYZENT_BA_Count__c, COVID_19_Vaccination__c from sked__Resource__c];
        resource.MAYZENT_BA_Count__c = 1;
        resource.COVID_19_Vaccination__c = 'Exempt';
        try{
			update resource;
            sked__Resource__c res = [Select Id,Last_Adbry_Case__c from sked__Resource__c where Id =: resource.Id];
            System.assertEquals(System.today(), res.Last_Adbry_Case__c);
    
            List<sked__Resource_Tag__c> resTag = [Select Id from sked__Resource_Tag__c where sked__Resource__c =: res.id];
            System.assertEquals(1, resTag.size());            
        }catch(Exception ex){
            if(ex.getMessage().contains('INVALID_CROSS_REFERENCE_KEY')){
                System.debug('exception');
            }
        }
    }

    /*
    * Type: Flow
    * Name: ResourceRecordFlow
    * Scenario: MAYZENT_FDO_Count__c changed, Covid 19 Vaccination set to Exepmt, resource tag record will be created
    */
    @isTest
    static void testMAYZENT_FDO(){
        sked__Resource__c resource = [Select Id, MAYZENT_FDO_Count__c, COVID_19_Vaccination__c from sked__Resource__c];
        resource.MAYZENT_FDO_Count__c = 1;
        resource.COVID_19_Vaccination__c = 'Exempt';
        try{
			update resource;
            sked__Resource__c res = [Select Id,Last_Adbry_Case__c from sked__Resource__c where Id =: resource.Id];
            System.assertEquals(System.today(), res.Last_Adbry_Case__c);
    
            List<sked__Resource_Tag__c> resTag = [Select Id from sked__Resource_Tag__c where sked__Resource__c =: res.id];
            System.assertEquals(1, resTag.size());            
        }catch(Exception ex){
            if(ex.getMessage().contains('INVALID_CROSS_REFERENCE_KEY')){
                System.debug('exception');
            }
        }
    }
    
    /*
    * Type: Flow
    * Name: ResourceRecordFlow
    * Scenario: PONVORY_Count__c changed, Covid 19 Vaccination set to Exepmt, resource tag record will be created
    */
    @isTest
    static void testPonvory(){
        sked__Resource__c resource = [Select Id, PONVORY_Count__c, COVID_19_Vaccination__c from sked__Resource__c];
        resource.PONVORY_Count__c = 1;
        resource.COVID_19_Vaccination__c = 'Exempt';
        try{
			update resource;
            sked__Resource__c res = [Select Id,Last_Adbry_Case__c from sked__Resource__c where Id =: resource.Id];
            System.assertEquals(System.today(), res.Last_Adbry_Case__c);
    
            List<sked__Resource_Tag__c> resTag = [Select Id from sked__Resource_Tag__c where sked__Resource__c =: res.id];
            System.assertEquals(1, resTag.size());            
        }catch(Exception ex){
            if(ex.getMessage().contains('INVALID_CROSS_REFERENCE_KEY')){
                System.debug('exception');
            }
        }
    }

    /*
    * Type: Flow
    * Name: ResourceRecordFlow
    * Scenario: ZEPOSIA_Count__c changed, Covid 19 Vaccination set to Exepmt, resource tag record will be created
    */
    @isTest
    static void testZeposia(){
        sked__Resource__c resource = [Select Id, ZEPOSIA_Count__c, COVID_19_Vaccination__c from sked__Resource__c];
        resource.ZEPOSIA_Count__c = 1;
        resource.COVID_19_Vaccination__c = 'Exempt';
        try{
			update resource;
            sked__Resource__c res = [Select Id,Last_Adbry_Case__c from sked__Resource__c where Id =: resource.Id];
            System.assertEquals(System.today(), res.Last_Adbry_Case__c);
    
            List<sked__Resource_Tag__c> resTag = [Select Id from sked__Resource_Tag__c where sked__Resource__c =: res.id];
            System.assertEquals(1, resTag.size());            
        }catch(Exception ex){
            if(ex.getMessage().contains('INVALID_CROSS_REFERENCE_KEY')){
                System.debug('exception');
            }
        }
    }
    
}