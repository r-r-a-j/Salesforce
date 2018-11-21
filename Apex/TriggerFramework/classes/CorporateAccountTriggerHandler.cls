global class CorporateAccountTriggerHandler extends TriggerHandler 
{
    global override void common()
    {
        System.debug('=== CorporateAccountTriggerHandler: COMMON() WAS CALLED: FUTURE?: ' + System.isFuture());
        System.debug('=== CorporateAccountTriggerHandler: COMMON() LISTS: NEW: ' + Trigger.New + '  == OLD: ' + Trigger.Old);        
    }
    
    global override void afterInsert() { System.debug('=== CorporateAccountTriggerHandler: afterInsert() called. Trigger Values: ' + Trigger.New + Trigger.Old); }
    global override void beforeUpdate() { System.debug('=== CorporateAccountTriggerHandler: beforeUpdate() called. Trigger Values: ' + Trigger.New + Trigger.Old); }
    global override void afterUpdate() { System.debug('=== CorporateAccountTriggerHandler: afterUpdate() called. Trigger Values: ' + Trigger.New + Trigger.Old); }
    global override void beforeDelete() { System.debug('=== CorporateAccountTriggerHandler: beforeDelete() called. Trigger Values: ' + Trigger.New + Trigger.Old); }
    global override void afterDelete() { System.debug('=== CorporateAccountTriggerHandler: afterDelete() called. Trigger Values: ' + Trigger.New + Trigger.Old); }
    global override void afterUndelete() { System.debug('=== CorporateAccountTriggerHandler: afterUndelete() called. Trigger Values: ' + Trigger.New + Trigger.Old); }


    global override void commonFuture(Set<ID> newIDs, Set<ID> oldIDs)
    {
        System.debug('=== CorporateAccountTriggerHandler: COMMONFUTURE() WAS CALLED: FUTURE?: ' + System.isFuture());
        System.debug('=== CorporateAccountTriggerHandler: COMMONFUTURE() LISTS: NEW: ' + newIDs + '  == OLD: ' + oldIDs + '  == AFTER: ' + Trigger.IsAfter);        
    }
    
    global override void afterInsertFuture(Set<ID> newIDs, Set<ID> oldIDs) 
    {
        System.debug('=== CorporateAccountTriggerHandler: afterInsertFuture() WAS CALLED: FUTURE?: ' + System.isFuture());
        System.debug('=== CorporateAccountTriggerHandler: afterInsertFuture() LISTS: NEW: ' + newIDs + '  == OLD: ' + oldIDs + '  == AFTER: ' + Trigger.IsAfter);        
    }
    
    global override void beforeUpdateFuture(Set<ID> newIDs, Set<ID> oldIDs) 
    {
        System.debug('=== CorporateAccountTriggerHandler: beforeUpdateFuture() WAS CALLED: FUTURE?: ' + System.isFuture());
        System.debug('=== CorporateAccountTriggerHandler: beforeUpdateFuture() LISTS: NEW: ' + newIDs + '  == OLD: ' + oldIDs + '  == AFTER: ' + Trigger.IsAfter);        
    }
    
    global override void afterUpdateFuture(Set<ID> newIDs, Set<ID> oldIDs) 
    {
        System.debug('=== CorporateAccountTriggerHandler: afterUpdateFuture() WAS CALLED: FUTURE?: ' + System.isFuture());
        System.debug('=== CorporateAccountTriggerHandler: afterUpdateFuture() LISTS: NEW: ' + newIDs + '  == OLD: ' + oldIDs + '  == AFTER: ' + Trigger.IsAfter);        
    }
    
    global override void beforeDeleteFuture(Set<ID> newIDs, Set<ID> oldIDs) 
    {
        System.debug('=== CorporateAccountTriggerHandler: beforeDeleteFuture() WAS CALLED: FUTURE?: ' + System.isFuture());
        System.debug('=== CorporateAccountTriggerHandler: beforeDeleteFuture() LISTS: NEW: ' + newIDs + '  == OLD: ' + oldIDs + '  == AFTER: ' + Trigger.IsAfter);        
    }
    
    global override void afterDeleteFuture(Set<ID> newIDs, Set<ID> oldIDs) 
    {
        System.debug('=== CorporateAccountTriggerHandler: afterDeleteFuture() WAS CALLED: FUTURE?: ' + System.isFuture());
        System.debug('=== CorporateAccountTriggerHandler: afterDeleteFuture() LISTS: NEW: ' + newIDs + '  == OLD: ' + oldIDs + '  == AFTER: ' + Trigger.IsAfter);        
    }
    
    global override void afterUndeleteFuture(Set<ID> newIDs, Set<ID> oldIDs) 
    {
        System.debug('=== CorporateAccountTriggerHandler: afterUndeleteFuture() WAS CALLED: FUTURE?: ' + System.isFuture());
        System.debug('=== CorporateAccountTriggerHandler: afterUndeleteFuture() LISTS: NEW: ' + newIDs + '  == OLD: ' + oldIDs + '  == AFTER: ' + Trigger.IsAfter);        
    }
}