-- submissions monitoring view

CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `user`@`%` 
    SQL SECURITY DEFINER
VIEW `submissions_monitoring_view` AS
    SELECT 
        `ps`.`id` AS `submission_id`,
        `ps`.`organization_id` AS `org_id`,
        `o`.`name` AS `org_name`,
        `ps`.`form_id` AS `form_id`,
        `f`.`name` AS `form_name`,
        CONCAT('www/',
                `ps`.`organization_id`,
                '/forms/',
                `ps`.`form_id`) AS `form_url`,
        `d`.`identifier` AS `device_id`,
        `d`.`owner` AS `device_owner`,
        CONCAT('www',
                `ps`.`organization_id`,
                '/devices/',
                `ps`.`device_id`) AS `device_url`,
        DATE_FORMAT(`ps`.`updated_at`, '%d-%m-%Y') AS `sub_update_full_date`,
        DAYOFMONTH(`ps`.`updated_at`) AS `sub_update_day`,
        MONTH(`ps`.`updated_at`) AS `sub_update_month`,
        YEAR(`ps`.`updated_at`) AS `sub_update_year`,
        CAST(`ps`.`updated_at` AS TIME) AS `sub_update_full_time`,
        HOUR(`ps`.`updated_at`) AS `sub_update_hour`,
        MINUTE(`ps`.`updated_at`) AS `sub_update_minute`,
        SECOND(`ps`.`updated_at`) AS `sub_update_second`
    FROM
        (((`pending_submissions` `ps`
        LEFT JOIN `organizations` `o` ON (`ps`.`organization_id` = `o`.`id`))
        LEFT JOIN `forms` `f` ON (`ps`.`form_id` = `f`.`id`))
        LEFT JOIN `devices` `d` ON (`ps`.`device_id` = `d`.`id`))
    WHERE
        `ps`.`duplicate` = 0
            AND `d`.`device_status_id` = 3
            AND CAST(`ps`.`created_at` AS DATE) >= '2023-10-01'
    ORDER BY `ps`.`id` DESC;
