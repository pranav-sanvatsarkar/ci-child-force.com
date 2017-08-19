trigger TestTriggerParent on TestCIParentObject__c (before insert) {
System.debug('Hello!');
}