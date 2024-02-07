-- submissions monitoring view

CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `xxx` 
    SQL SECURITY DEFINER
VIEW `submissions_monitoring_view` AS
    SELECT
        `submissions_monitoring_view`.`submission_id` AS `submission_id`,
        `submissions_monitoring_view`.`org_id` AS `org_id`,
        `submissions_monitoring_view`.`org_name` AS `org_name`,
        `submissions_monitoring_view`.`form_id` AS `form_id`,
        `submissions_monitoring_view`.`form_name` AS `form_name`,
        `submissions_monitoring_view`.`form_url` AS `form_url`,
        `submissions_monitoring_view`.`device_id` AS `device_id`,
        `submissions_monitoring_view`.`device_owner` AS `device_owner`,
        `submissions_monitoring_view`.`device_url` AS `device_url`,
        `submissions_monitoring_view`.`sub_create_full_date` AS `sub_create_full_date`,
        `submissions_monitoring_view`.`sub_update_full_date` AS `sub_update_full_date`,
        TIMESTAMPDIFF(DAY,
            STR_TO_DATE(`submissions_monitoring_view`.`sub_create_full_date`,
                    '%d-%m-%Y'),
            STR_TO_DATE(`submissions_monitoring_view`.`sub_update_full_date`,
                    '%d-%m-%Y')) AS `difference_in_days`,
        `submissions_monitoring_view`.`sub_update_day` AS `sub_update_day`,
        `submissions_monitoring_view`.`sub_update_month` AS `sub_update_month`,
        `submissions_monitoring_view`.`sub_update_year` AS `sub_update_year`,
        `submissions_monitoring_view`.`sub_update_full_time` AS `sub_update_full_time`,
        `submissions_monitoring_view`.`sub_update_hour` AS `sub_update_hour`,
        `submissions_monitoring_view`.`sub_update_minute` AS `sub_update_minute`,
        `submissions_monitoring_view`.`sub_update_second` AS `sub_update_second`
    FROM
        (SELECT 
                `ps`.`id` AS `submission_id`,
                `ps`.`organization_id` AS `org_id`,
                `o`.`name` AS `org_name`,
                `ps`.`form_id` AS `form_id`,
                `f`.`name` AS `form_name`,
                CONCAT('https://xxx', `ps`.`organization_id`, 'xxx', `ps`.`form_id`) AS `form_url`,
                `d`.`identifier` AS `device_id`,
                `d`.`owner` AS `device_owner`,
                CONCAT('https://xxx', `ps`.`organization_id`, 'xxx', `ps`.`device_id`) AS `device_url`,
                DATE_FORMAT(`ps`.`created_at`, '%d-%m-%Y') AS `sub_create_full_date`,
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
                AND `ps`.`delivered` = 1
                AND CAST(`ps`.`updated_at` AS DATE) >= '2023-10-01'
        ORDER BY `ps`.`id` DESC) `submissions_monitoring_view`
