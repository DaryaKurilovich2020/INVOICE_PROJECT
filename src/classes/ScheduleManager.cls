public with sharing class ScheduleManager {

    public static final String CREATE_ORDERS_SCHEDULED_JOB_NAME = 'Create Scheduled Orders';
    public static final String SEND_EMAILS_SCHEDULED_JOB_NAME = 'Send Scheduled Email';

    public static final Map<String, Object> SCHEDULERS = new Map<String, Object>{
        CREATE_ORDERS_SCHEDULED_JOB_NAME => new Map<String, Object>{
            'type' => CreateOrdersScheduleProc.class,
                    'cron' => '0 0 19 L * ? *'                         //on 1st day every month at 11 pm (Moscow time)
        //TODO check timezone
        },
        SEND_EMAILS_SCHEDULED_JOB_NAME => new Map<String, Object>{
            'type' => SendEmailScheduleProc.class,
            'cron' => '0 0 20 L * ? *'                       //the last day of every month at 12 pm (Moscow time)
        }
    };


    public static void restart() {
        stopAll();
        startAll();
    }

    public static void startAll() {
        for (String jobName : SCHEDULERS.keySet()) {

            Map<String, Object> scheduleSetting = (Map<String, Object>) SCHEDULERS.get(jobName);
            Type typeVar = (Type) scheduleSetting.get('type');

            System.schedule(
                jobName,
                (String) scheduleSetting.get('cron'),
                (Schedulable) typeVar.newInstance()
            );
        }
    }

    public static void stopAll() {
        for (CronTrigger delCron : [
            SELECT Id
            FROM CronTrigger
            WHERE CronJobDetail.Name IN :SCHEDULERS.keySet()
            WITH SECURITY_ENFORCED
        ]) {
            System.abortJob(delCron.Id);
        }
    }

}