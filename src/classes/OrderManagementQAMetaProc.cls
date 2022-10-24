public class OrderManagementQAMetaProc extends vertic_MetadataProcessor {

    public override vertic_Response process(vertic_Request request) {
        this.request = request == null ? new vertic_MetadataProcessor.MetadataRequest() : (vertic_MetadataProcessor.MetadataRequest) request;

        this.request.fields = new Set<SObjectField>{
            // SObject Fields, e.g. Contact.Salutation
        };

        super.process(this.request);

        this.init();

        return this.response;
    }

    private void init() {
        String recordId = request.getString('recordId');
        Order orderVar = (Order) vertic_Utils.arrays.firstOrException([
            SELECT Id, Account.Name, EffectiveDate, Pricebook2Id, Pricebook2.Name, ContractId, TotalAmount, (SELECT Id, Quantity, UnitPrice, Total__c, Product2.Contact__c, Product2.Contact__r.Name, Working_Hours__c FROM OrderItems)
            FROM Order
            WHERE Id = :recordId
        ]);
        Boolean allowReportSend = true;
        Decimal orderTotal = 0;
        for (OrderItem item : orderVar.OrderItems) {
            orderTotal += item.Total__c;
            if (item.Total__c == 0) {
                allowReportSend = false;
            }
        }
        response.put('orderTotal', orderTotal);
        response.put('allowSubmit', allowReportSend);
        response.put('order', orderVar);
        response.put('orderItems', orderVar.OrderItems);
        List<PricebookEntry> entries = [SELECT Id, UnitPrice, Product2Id FROM PricebookEntry WHERE Pricebook2Id = :orderVar.Pricebook2Id];
        if (entries.size() != orderVar.OrderItems.size()) {
            response.put('isValidOrder', false);
        } else {
            response.put('isValidOrder', true);
        }

    }
}