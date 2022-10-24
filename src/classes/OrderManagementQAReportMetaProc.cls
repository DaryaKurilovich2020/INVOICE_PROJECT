public class OrderManagementQAReportMetaProc extends vertic_MetadataProcessor {

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
        initComponents();
    }


    private void initComponents() {

        List<Object> components = new List<Object>();
        vertic_DTO dto = new vertic_DTO();

        String orderId = this.request.getString('orderId');
        Order orderVar = (Order) vertic_Utils.arrays.firstOrException([
            SELECT Id, Account.Name, EffectiveDate, Pricebook2Id, Pricebook2.Name, ContractId, TotalAmount, (SELECT Id, Quantity, UnitPrice, Total__c, Product2.Contact__c, Product2.Contact__r.Name, Working_Hours__c FROM OrderItems)
            FROM Order
            WHERE Id = :orderId
        ]);
        Decimal orderTotal = 0;
        for (OrderItem item : orderVar.OrderItems) {
            orderTotal += item.Total__c;
        }
        dto.put('total', orderTotal);
        dto.put('order', orderVar);
        dto.put('orderItems', orderVar.OrderItems);
        components.add(new Component.OrderManagementQAReport(
            dto = dto.getMap()
        ));

        this.response.dto.put('components', components);
        this.response.dto.put('head-component', new Component.OrderManagementQAReportStyles());
        System.debug('components ' + components);
    }
}