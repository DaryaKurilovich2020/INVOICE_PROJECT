({
    handleSubmitClick : function (cmp, event, helper) {
        var instanceUrl = cmp.get('v.meta.dto.instanceURL'),
            orderId = cmp.get('v.meta.dto.order.Id'),
            procName = event.getSource().getLocalId()
        if (instanceUrl && procName && orderId) {
            window.open(instanceUrl + '/apex/vertic_Content?proc=' + procName + '&renderAs=pdf' + '&orderId=' + orderId, '_blank');
        }
    }
});