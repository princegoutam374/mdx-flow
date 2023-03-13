@isTest
private class skedResourceLoginController_Test {

    @isTest
    private static void testController(){
        Test.startTest();
        
        Test.setCurrentPage(new PageReference('/apex/skedResourceLogin?retURL=/home.jsp'));
        
        skedResourceLoginController controller = new skedResourceLoginController();
        PageReference page = controller.next();
        System.assert(page == null);
        
        Test.stopTest();
    }
}