public class TestClass
{
    TestCIParentObject__c parentObj = new TestCIParentObject__c();
    public TestClass()
    {
        parentObj.Name__c='John';
        parentObj.Email__c= 'test@test.com';
        system.debug('Hello !!! '+parentObj.Name__c);
    }
}