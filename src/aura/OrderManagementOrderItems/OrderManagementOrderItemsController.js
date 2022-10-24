({
    handleRemindClick: function (cmp, event, helper) {
        return helper.utils(cmp).executePromise(
            cmp,
            'SendReminderProc',
            {
                contactId: cmp.get('v.orderItem.Contact__c')
            }
        )
            .then($A.getCallback(() => {
                return cmp.find('notifLib').showToast({
                    variant: 'success',
                    message: 'The reminder to {0} has been sent.',
                    messageData: [{
                        label: response.dto.contact.Name,
                        url: '/' + response.dto.contact.Id
                    }]
                });
            }))
            .finally($A.getCallback(() => {
                cmp.set('v.isBusy', false);
            }));
    },
    getUrl:function (cmp,event, helper) {

        return '/' + cmp.get('orderItem').orderItem.Product2.Contact__c;
    }
});