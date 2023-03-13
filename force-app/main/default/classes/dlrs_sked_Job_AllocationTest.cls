/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_sked_Job_AllocationTest
{
    @IsTest
    private static void testTrigger()
    {
        // Force the dlrs_sked_Job_AllocationTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new sked__Job_Allocation__c());
    }
}