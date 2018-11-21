global class AccountTriggerHandler extends TriggerHandler 
{
	global override void common()
    {
        System.debug('=== AccountTriggerHandler: COMMON() WAS CALLED: UPDATE?: ' + Trigger.IsUpdate);
    }

    global override void beforeInsert() { System.debug('=== AccountTriggerHandler: beforeInsert() called. Trigger Values: ' + Trigger.New + Trigger.Old); }
    global override void afterInsert() { System.debug('=== AccountTriggerHandler: afterInsert() called. Trigger Values: ' + Trigger.New + Trigger.Old); }
    global override void beforeUpdate() { System.debug('=== AccountTriggerHandler: beforeUpdate() called. Trigger Values: ' + Trigger.New + Trigger.Old); }
    global override void afterUpdate() { System.debug('=== AccountTriggerHandler: afterUpdate() called. Trigger Values: ' + Trigger.New + Trigger.Old); }
    global override void beforeDelete() { System.debug('=== AccountTriggerHandler: beforeDelete() called. Trigger Values: ' + Trigger.New + Trigger.Old); }
    global override void afterDelete() { System.debug('=== AccountTriggerHandler: afterDelete() called. Trigger Values: ' + Trigger.New + Trigger.Old); }
    global override void afterUndelete() { System.debug('=== AccountTriggerHandler: afterUndelete() called. Trigger Values: ' + Trigger.New  + Trigger.Old); }
}