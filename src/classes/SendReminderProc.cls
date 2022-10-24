public class SendReminderProc extends vertic_AbstractProcessor implements vertic_Structs.IRollbackable {

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.doSubmit();

        return this.response;
    }

    private void doSubmit() {
        String contactId = this.request.getString('contactId');
        vertic_AsyncProcess asyncProcess = new vertic_AsyncProcess();
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
        asyncProcess.enqueue();
        Contact contactVar = (Contact) vertic_Utils.arrays.firstOrException([SELECT Id, Name FROM Contact WHERE Id = :contactId]);
        this.response.put('contact', contactVar);
    }
}