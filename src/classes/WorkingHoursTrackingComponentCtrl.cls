public class WorkingHoursTrackingComponentCtrl {
    public Id contactId { get; set; }
    public String getSiteUrl() {
        Site whtSite = [SELECT Id FROM Site WHERE Name = 'Working_Hours_Tracking'];
        String siteUrl = [SELECT SecureURL FROM SiteDetail where DurableId = :whtSite.Id].SecureUrl;
        siteUrl += '?contactId=' + contactId;
        return siteUrl;
    }
}