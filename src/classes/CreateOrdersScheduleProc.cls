global class CreateOrdersScheduleProc implements Schedulable {

    global void execute(SchedulableContext SC) {
        new CreateOrdersScheduleProc().process();
    }

    public void process() {
        List<Order> newOrders = createOrders();
        createOrderItems(newOrders);
    }

    public List<Order> createOrders() {
        List<Account> companies = [SELECT Id, (SELECT Id, Pricebook2Id FROM Contracts) FROM Account];
        List<Order> ordersToCreate = new List<Order>();
        for (Account companyVar : companies) {
            if (companyVar.Contracts.size() > 1) {
                throw new fflib_QueryFactory.InvalidFieldException('Account can have only one contract');
            }
            if (companyVar.Contracts.size() == 1) {
                Order newOrder = new Order(
                    AccountId = companyVar.Id,
                    ContractId = companyVar.Contracts[0].Id,
                    Pricebook2Id = companyVar.Contracts[0].Pricebook2Id,
                    EffectiveDate = Date.today(),
                    Status = 'Draft'
                );
                ordersToCreate.add(newOrder);
            }
        }
        insert ordersToCreate;
        return ordersToCreate;
    }

    public void createOrderItems(List<Order> orders) {
        List<OrderItem> orderItemsToCreate = new List<OrderItem>();

        List<String> priceBooksIds = new List<String>();
        for (Order orderVar : orders) {
            priceBooksIds.add(orderVar.Pricebook2Id);
        }

        List<PricebookEntry> priceBooksEntries = [SELECT Id, Product2Id, Pricebook2Id, UnitPrice FROM PricebookEntry WHERE Pricebook2Id IN :priceBooksIds AND Pricebook2.IsActive = true];
        for (Order orderVar : orders) {
            for (PricebookEntry entry : priceBooksEntries) {
                if (orderVar.Pricebook2Id == entry.Pricebook2Id) {
                    OrderItem newOrderItem = new OrderItem(
                        Product2Id = entry.Product2Id,
                        OrderId = orderVar.Id,
                        PricebookEntryId = entry.Id,
                        UnitPrice = entry.UnitPrice,
                        Quantity = 1
                    );
                    orderItemsToCreate.add(newOrderItem);
                }
            }
        }

        insert orderItemsToCreate;
    }
}