global virtual interface TriggerInterface 
{
    // NOTE: a given Handler will implement only one set of these: synch, future, or queued
        
    void common(); // call this first (and only once) before other handler methods
    void beforeInsert();
    void afterInsert();
    void beforeUpdate();
    void afterUpdate();
    void beforeDelete();
    void afterDelete();
    void afterUndelete(); 
    
	void commonFuture(Set<Id> newIDs, Set<Id> oldIDs);
    void afterInsertFuture(Set<Id> newIDs, Set<Id> oldIDs);
    void beforeUpdateFuture(Set<Id> newIDs, Set<Id> oldIDs);
    void afterUpdateFuture(Set<Id> newIDs, Set<Id> oldIDs);
    void beforeDeleteFuture(Set<Id> newIDs, Set<Id> oldIDs);
    void afterDeleteFuture(Set<Id> newIDs, Set<Id> oldIDs);
    void afterUndeleteFuture(Set<Id> newIDs, Set<Id> oldIDs); 

	void commonQueued(Trig trigVar);
    void afterInsertQueued();
    void beforeUpdateQueued();
    void afterUpdateQueued();
    void beforeDeleteQueued();
    void afterDeleteQueued();
    void afterUndeleteQueued();
    //void execute(QueueableContext qc);    
}