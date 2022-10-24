global class SendEmailScheduleProc implements Schedulable {

    global void execute(SchedulableContext context) {
        new SendEmailScheduleProc().process();
    }

    global void process() {
        sendEmails();
    }

    private List<String> getContactIds() {
        List<String> contactIds = new List<String>();
        List<Product2> productsList = [SELECT Id, Contact__c FROM Product2 WHERE IsActive = TRUE];
        for (Product2 productVar : productsList) {
            contactIds.add(productVar.Contact__c);
        }
        return contactIds;
    }

    private void sendEmails() {
        List<String> contactsIds = getContactIds();
        vertic_AsyncProcess asyncProcess = new vertic_AsyncProcess();
        for (String contactId : contactsIds) {
            vertic_SendEmailProc.EmailAsyncProcess emailAsyncProcess = new vertic_SendEmailProc.EmailAsyncProcess(
                'Email_for_products',
                contactId,
                null);
            Vertic_Async_Process__c vap = emailAsyncProcess.toAsyncProcess();
            vap.Description__c = 'Monthly email';
            vap.Allowed_Attempts__c = 1;
            vap.Group_Key__c = String.valueOf(Date.today());
            vap.Processor__c = '' + vertic_SendEmailProc.class;
            asyncProcess.add(vap);
        }
        asyncProcess.enqueue();
    }
}