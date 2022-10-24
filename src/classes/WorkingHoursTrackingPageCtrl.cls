public class WorkingHoursTrackingPageCtrl {
    public Integer workingHours { get; set; }
    public Contact contactVar { get; set; }

    public WorkingHoursTrackingPageCtrl() {
        String contactId = ApexPages.currentPage().getParameters().get('contactId');
        this.contactVar = [SELECT Id, Name FROM Contact WHERE Id = :contactId LIMIT 1];
    }

    public String getName() {
        return this.contactVar.Name;
    }

    public void saveHours() {
        String contactId = ApexPages.currentPage().getParameters().get('contactId');
        OrderItem orderItemVar = [SELECT Working_Hours__c, Quantity FROM OrderItem WHERE Product2.Contact__c = :contactId ORDER BY CreatedDate LIMIT 1];
        orderItemVar.Working_Hours__c = workingHours;
        update orderItemVar;

    }
}