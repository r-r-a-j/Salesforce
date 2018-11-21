/*
 * Trigger Framework for use by developers to avoid Trigger conflict, recursion control, 
 *   dynamic enable/disable and externalization of Trigger logic to classes. 
 *   
*/
global virtual class TriggerHandler implements TriggerInterface,Queueable 
{
    public class InvalidActionException extends Exception { }
    public static Map<Id, Trigger_Handler__mdt> trigMap;
    public static String currentClass = 'TriggerHandler'; 

    /* Control recursion by className+actionName
	 * If null, initialize to zero and allow;
	 * if non-null, check value before executing method;
	 * after calling method, increment the counter. 
	*/
    public static Map<String,Map<String,Integer>> callCountMap = new Map<String,Map<String,Integer>>();
	public static Map<TriggerOperation,String> opActionMap = new Map<TriggerOperation,String>();
	public static Map<String,TriggerOperation> actionOpMap = new Map<String,TriggerOperation>();
    public static Boolean firstTime = true;
/*    
    global TriggerHandler() // super()
    {        
    }
*/
/*    
    // For Asynch queued Apex:
    global TriggerHandler(List<SObject> newList, List<SObject> oldList, Map<Id,SObject> newmap, Map<Id,SObject> OldMap, 
                          Boolean before, Boolean after, Boolean isInsert, Boolean isUpdate, 
                          Boolean isDelete, Boolean isUnDelete) 
    {        
    }
*/
    
    global static void run(Schema.SObjectType sot) // main-entry
    { 
		Trigger_Handler__mdt handlerRec = null;
        
        try
        {
            String objName = sot.getDescribe().getName();

            String action = initializeActions(); 
			System.debug('=== CURRENT ACTION: ' + action);
            
            trigMap = new Map<Id,Trigger_Handler__mdt>([SELECT DeveloperName,Enabled__c,Object_Name__c,
                                                         AfterInsert_Recurse_Level__c,BeforeInsert_Recurse_Level__c,
                                                         BeforeUpdate_Recurse_Level__c,AfterUpdate_Recurse_Level__c,
                                                         BeforeDelete_Recurse_Level__c,AfterDelete_Recurse_Level__c,
                                                         AfterUndelete_Recurse_Level__c,Run_Mode__c  
                                                        FROM Trigger_Handler__mdt WHERE Object_Name__c =: objName 
                                                        ORDER BY Object_Name__c,Exec_Order__c ]);
            
            System.debug('===TriggerHandler: run() was called');
                
            for (Trigger_Handler__mdt thRec : trigMap.values())
            {                
                handlerRec = thRec;  // save for exception scoping
				currentClass = thRec.DeveloperName;  // save who we are calling in global static
                String className = thRec.DeveloperName;  // save local copy
                
                if (thRec.Run_Mode__c.equalsIgnoreCase('Future') && action.equals('beforeInsert'))
                    continue; // cannot do @future with beforeInsert (no IDs)'; get out quick so beforeInsert does not preclude firstTime == true
                
                Type t = Type.forName(className);
                TriggerHandler th = (TriggerHandler)t.newInstance();

                System.debug('===TriggerHandler: class: ' + className);
                
                Map<String,Integer> actMap = callCountMap.get(className);
                Integer callCount;  // call counter
                
                if (actMap == null)
                {
	                System.debug('===TriggerHandler: ACTMAP NULL, TH REC: ' + thRec + '  == TH: ' + th);
                    String tmp = 'common'; // first time in, so we call common()
                    actMap = new Map<String,Integer>();
                    firstTime = true;
                    if (thRec.Run_Mode__c.equalsIgnoreCase('Future'))
                        action = 'common'; // override since there is no beforeInsert and we call commonFuture once also
                    callCount = 0;
                    actMap.put(tmp, callCount);
                    callCountMap.put(className,actMap); // null first time                    
                    initCallCountMap(className); // initialize rest of action counts
                }
                else
                {
	                System.debug('===TriggerHandler: ACTMAP NONNULL, TH REC: ' + thRec + '  == TH: ' + th);
                    firstTime = false;
                    callCount = actMap.get(action);
                    if (callCount == null)
                        throw new InvalidActionException('=== Action does not exist: ' + action);
                }
                
                if (!thRec.Enabled__c)
                    continue;  // it is disabled

				if (callCount > getRecurseLevel(thRec,action))
                	continue;  // it has already been called too many times

                if (firstTime && thRec.Run_Mode__c.equalsIgnoreCase('Synchronous'))
	                th.common(); // we always call common once per handler-class and call it first
                else if (thRec.Run_Mode__c.equalsIgnoreCase('Future') && !action.equals('beforeInsert') 
                         && !System.isFuture())
                {
                    Map<Id,SObject> nm;
                    if (Trigger.New == null)
                        nm = new Map<Id,SObject>();
                    else
						nm = new Map<Id,SObject>(Trigger.New);   
			        Map<Id,SObject> om;
       				if(Trigger.Old != null) 
                        om = new Map<Id,SObject>(Trigger.Old);
					else 
                        om = new Map<Id, SObject>();
                    commonFuture(nm.keyset(), om.keyset(), className, action);
					continue; // if asynch, we only execute Future version of methods // was "return;" statement before                  
                }
                else if (thRec.Run_Mode__c.equalsIgnoreCase('Asynch Queued'))
                {
                    Trig trigVars = new Trig(Trigger.New, Trigger.Old, Trigger.newMap, Trigger.oldMap, 
                    						 Trigger.IsBefore, Trigger.IsAfter, Trigger.IsInsert,  
                    						 Trigger.IsUpdate, Trigger.IsDelete, Trigger.IsUndelete);
                    
                    if (firstTime)
	                    th.commonQueued(trigVars);
                    
                    dispatchQueued(trigVars, th, action);
                }
  
                switch on action 
                {
                    when 'beforeInsert'
                    	{ th.beforeInsert(); }
                    when 'afterInsert' 
	                    { th.afterInsert(); }
                	when 'beforeUpdate' 
	                    { th.beforeUpdate(); }
                    when 'afterUpdate'
                    	{ th.afterUpdate(); }
                	when 'beforeDelete'
                    	{ th.beforeDelete(); }            
                	when 'afterDelete'
                    	{ th.afterDelete(); } 
                    when 'afterUndelete' 
                    	{ th.afterUndelete();}
                }
                
				callCount = actMap.get(action);
	            actMap.put(action,++callCount); 
                callCountMap.put(className, actMap);
            }
        }
        catch (Exception e)
        {
            System.debug('=== Exception in TriggerHandler via Class: ' + currentClass + '   == Handler: ' + handlerRec);
            throw e; // re-throw for now
        }
    }

    public static Integer getRecurseLevel(Trigger_Handler__mdt thRec, String action)
    {
        Decimal level = 1;

        switch on action 
        {
            when 'beforeInsert'
            { level = thRec.BeforeInsert_Recurse_Level__c; }
            when 'afterInsert' 
            { level = thRec.AfterInsert_Recurse_Level__c; }
            when 'beforeUpdate' 
            { level = thRec.BeforeUpdate_Recurse_Level__c; }
            when 'afterUpdate'
            { level = thRec.AfterUpdate_Recurse_Level__c; }
            when 'beforeDelete'
            { level = thRec.BeforeDelete_Recurse_Level__c; }            
            when 'afterDelete'
            { level = thRec.AfterDelete_Recurse_Level__c; } 
            when 'afterUndelete' 
            { level = thRec.AfterUndelete_Recurse_Level__c;}
        }
        
        return level.intValue();
    }
    
    public static String initializeActions()
    {
        String retAction;

        if (Trigger.IsInsert)
        {
            if (Trigger.IsBefore)
				retAction = 'beforeInsert';
            else
				retAction = 'afterInsert';
        }
        else if (Trigger.IsUpdate)  
        {
            if (Trigger.IsBefore)
                retAction = 'beforeUpdate';
            else
                retAction = 'afterUpdate';
        }
        else if (Trigger.IsDelete)
        {
            if (Trigger.IsBefore)
            	retAction = 'beforeDelete';
			else            
            	retAction = 'afterDelete';
        }
        else
            retAction = 'afterUndelete';
        
        String action; 
        for (TriggerOperation op : TriggerOperation.values())
        {
            if (op.equals(TriggerOperation.AFTER_DELETE))
        	{
                action = 'afterDelete';
                opActionMap.put(TriggerOperation.AFTER_DELETE, action);
                actionOpMap.put(action,TriggerOperation.AFTER_DELETE);
            }
            else if (op.equals(TriggerOperation.AFTER_INSERT))
            {
                action = 'afterInsert';
                opActionMap.put(TriggerOperation.AFTER_INSERT, action);
                actionOpMap.put(action,TriggerOperation.AFTER_INSERT);
            }
            else if (op.equals(TriggerOperation.AFTER_UNDELETE))
            {
                action = 'afterUndelete';
                opActionMap.put(TriggerOperation.AFTER_UNDELETE, action);
                actionOpMap.put(action,TriggerOperation.AFTER_UNDELETE);
            }
            else if (op.equals(TriggerOperation.AFTER_UPDATE))
            {
                action = 'afterUpdate';
                opActionMap.put(TriggerOperation.AFTER_UPDATE, action);
                actionOpMap.put(action,TriggerOperation.AFTER_UPDATE);
            }
            else if (op.equals(TriggerOperation.BEFORE_DELETE))
            {   
                action = 'beforeDelete';
                opActionMap.put(TriggerOperation.BEFORE_DELETE, action);
                actionOpMap.put(action,TriggerOperation.BEFORE_DELETE);
            }
            else if (op.equals(TriggerOperation.BEFORE_INSERT))
            { 
                action = 'beforeInsert';
                opActionMap.put(TriggerOperation.BEFORE_INSERT, action);
                actionOpMap.put(action,TriggerOperation.BEFORE_INSERT);
            }
            else if (op.equals(TriggerOperation.BEFORE_UPDATE))
            {       
                action = 'beforeUpdate';
                opActionMap.put(TriggerOperation.BEFORE_UPDATE, action);
                actionOpMap.put(action,TriggerOperation.BEFORE_UPDATE);
            }          
        }            
        
		return retAction;
    }
    
    public static void initCallCountMap(String className)
    {
        String action;
        Map<String,Integer> actMap = callCountMap.get(className);
        
        for (TriggerOperation op : TriggerOperation.values())
        {
        	action = opActionMap.get(op);
            actMap.put(action, 0);         
        }          
        callCountMap.put(className,actMap); // null first time
    }
    
    public static void resetRecursion(String className, TriggerOperation to)
    {
        String tmp = className + ':' + OpActionMap.get(to);
        Map<String,Integer> actMap = callCountMap.get(className);
		actMap.put(tmp,0); // reset to allow more recursion
		callCountMap.put(className, actMap);        
    } 
        
    global virtual void common(){ System.debug('=== TriggerHandler: common() called.'); }
    global virtual void beforeInsert() { System.debug('=== TriggerHandler: beforeInsert() called.'); }
    global virtual void afterInsert() { System.debug('=== TriggerHandler: afterInsert() called.'); }
    global virtual void beforeUpdate() { System.debug('=== TriggerHandler: beforeUpdate() called.'); }
    global virtual void afterUpdate() { System.debug('=== TriggerHandler: afterUpdate() called.'); }
    global virtual void beforeDelete() { System.debug('=== TriggerHandler: beforeDelete() called.'); }
    global virtual void afterDelete() { System.debug('=== TriggerHandler: afterDelete() called.'); }
    global virtual void afterUndelete() { System.debug('=== TriggerHandler: afterUndelete() called.'); }

    global virtual void commonFuture(Set<Id> newIDs, Set<Id> oldIDs){ System.debug('=== TriggerHandler: commonFuture() called.'); }
    global virtual void afterInsertFuture(Set<Id> newIDs, Set<Id> oldIDs) { System.debug('=== TriggerHandler: afterInsertFuture() called.'); }
    global virtual void beforeUpdateFuture(Set<Id> newIDs, Set<Id> oldIDs) { System.debug('=== TriggerHandler: beforeUpdateFuture() called.'); }
    global virtual void afterUpdateFuture(Set<Id> newIDs, Set<Id> oldIDs) { System.debug('=== TriggerHandler: afterUpdateFuture() called.'); }
    global virtual void beforeDeleteFuture(Set<Id> newIDs, Set<Id> oldIDs) { System.debug('=== TriggerHandler: beforeDeleteFuture() called.'); }
    global virtual void afterDeleteFuture(Set<Id> newIDs, Set<Id> oldIDs) { System.debug('=== TriggerHandler: afterDeleteFuture() called.'); }
    global virtual void afterUndeleteFuture(Set<Id> newIDs, Set<Id> oldIDs) { System.debug('=== TriggerHandler: afterUndeleteFuture() called.'); } 

    global virtual void commonQueued(Trig trigVar){ System.debug('=== TriggerHandler: commonQueued() called.'); }
    global virtual void beforeInsertQueued() { System.debug('=== TriggerHandler: beforeInsertQueued() called.'); }
    global virtual void afterInsertQueued() { System.debug('=== TriggerHandler: afterInsertQueued() called.'); }
    global virtual void beforeUpdateQueued() { System.debug('=== TriggerHandler: beforeUpdateQueued() called.'); }
    global virtual void afterUpdateQueued() { System.debug('=== TriggerHandler: afterUpdateQueued() called.'); }
    global virtual void beforeDeleteQueued() { System.debug('=== TriggerHandler: beforeDeleteQueued() called.'); }
    global virtual void afterDeleteQueued() { System.debug('=== TriggerHandler: afterDeleteQueued() called.'); }
    global virtual void afterUndeleteQueued() { System.debug('=== TriggerHandler: afterUndeleteQueued() called.'); }
    
	@future
    global static void commonFuture(Set<Id> newIDs, Set<Id> oldIDs, String classNam, String act)
    {
        Type t = Type.forName(classNam);
        TriggerHandler thand = (TriggerHandler)t.newInstance();
        
        switch on act 
        {
            when 'common' 
            	{ thand.commonFuture(newIDs, oldIDs); }
            when 'afterInsert' 
            	{ thand.afterInsertFuture(newIDs, oldIDs); }
            when 'beforeUpdate' 
            	{ thand.beforeUpdateFuture(newIDs, oldIDs); }
            when 'afterUpdate'
            	{ thand.afterUpdateFuture(newIDs, oldIDs); }
            when 'beforeDelete'
            	{ thand.beforeDeleteFuture(newIDs, oldIDs); }            
            when 'afterDelete'
            	{ thand.afterDeleteFuture(newIDs, oldIDs); } 
            when 'afterUndelete' 
            	{ thand.afterUndeleteFuture(newIDs, oldIDs);}
        }                
    } 
    
    private static void dispatchQueued(Trig trigVar, TriggerHandler thand, String act)
    {
        //Type t = Type.forName(classNam);
        //TriggerHandler thand = (TriggerHandler)t.newInstance();
        
        if (firstTime)
            thand.commonQueued(trigVar);
        
        switch on act 
        {
            when 'beforeInsert' 
            	{ thand.afterInsertQueued(); }
            when 'afterInsert' 
            	{ thand.afterInsertQueued(); }
            when 'beforeUpdate' 
            	{ thand.beforeUpdateQueued(); }
            when 'afterUpdate'
            	{ thand.afterUpdateQueued(); }
            when 'beforeDelete'
            	{ thand.beforeDeleteQueued(); }            
            when 'afterDelete'
            	{ thand.afterDeleteQueued(); } 
            when 'afterUndelete' 
            	{ thand.afterUndeleteQueued();}
        }                
    }     
    
	global virtual void execute(QueueableContext qc)
    {
		System.debug('=== TriggerHandler: execute() called.');        
    }    
}