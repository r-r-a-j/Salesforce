public class GuestReviewProcessor 
{
    @InvocableMethod(label = 'Process Guest Reviews' description = 'Process Guest Reviews')   
    public static List<GuestReviewResponse> processReviews(List<GuestReviewRequest> requests)
    {
        GuestReviewResponse response = new GuestReviewResponse();
        
        try
        {
            List<Guest_Review__c> lstGuestReviews = new List<Guest_Review__c>();
            
            //loop input List
            for(GuestReviewRequest req : requests)  
            {
                //TO-DO Insert Guest_Review__c record with contact (Contact__c), experience (Experience__c), rating (Rating__c), and review (Comments__c) 
                //variables in the processReviews method
                Guest_Review__c objGuestReview = new Guest_Review__c();
                objGuestReview.contact = req.contact;
                objGuestReview.experience = req.experience;
                objGuestReview.review = req.review;
                objGuestReview.rating = req.rating;
                
                lstGuestReviews.add(objGuestReview);
            }
            
            //insert
            insert lstGuestReviews;
            response.message = 'Reviews successfully updated!';
        }
        catch (Exception e)
        {
            //TO-DO Add exception handling code with a try-catch block   
            response.message = 'Reviews unsuccessfully - see appropriate error logs';        
        }
                
        //[OPTIONAL] Call CampaignMemberController.createCampaignMemberforRelatedCampaigns() in processReviews method 
             
        return new List<GuestReviewResponse> { response };
        
    }
    
    public class GuestReviewRequest{
        //TO-DO Build out GuestReviewRequest class with Invocable variables
        @InvocableVariable(required=true description='Contact record')
        public Contact contact;
        
        @InvocableVariable(required=true description='Record of the Experience that the Contact had')
        public Experience__c experience;
        
        @InvocableVariable(required=true description='Review of Experience')
        public String review;
        
        @InvocableVariable(required=true description='Rating given to Experience')
        public String rating;
    }
    
    
    public class GuestReviewResponse
    {
        //TO-DO Build out GuestReviewResponse class with Invocable variables
        @InvocableVariable(label = 'Status' description='Status')
        public String message;
        
    }    
    
}
