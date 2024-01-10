-- devices monitoring view

CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `user`@`%` 
    SQL SECURITY DEFINER
VIEW `devices_monitoring_view` AS
    SELECT 
        `d`.`id` AS `device_id`,
        `d`.`identifier` AS `idnt`,
        `d`.`owner` AS `owner`,
        `ds`.`name` AS `device_status`,
        `d`.`organization_id` AS `org_id`,
        `o`.`name` AS `org_name`,
        `o`.`short_name` AS `org_account_name`,
        DATE_FORMAT(`d`.`created_at`, '%d-%m-%Y') AS `creation_date`,
        DATE_FORMAT(`d`.`org_joined_at`, '%d-%m-%Y') AS `org_joined_date`,
        `d`.`device_model` AS `model`,
        CASE
            WHEN `d`.`push_provider` = 'iOS' THEN 'iOS'
            WHEN `d`.`push_provider` = 'GCM' THEN 'Android'
            ELSE 'Unknown'
        END AS `model_type`,
        `d`.`os_version` AS `os_version`,
        `d`.`app_version` AS `app_version`,
        `d`.`client_locale` AS `client_locale`,
        `d`.`last_ip_address` AS `last_ip_address`,
        CONCAT('www',
                `d`.`organization_id`,
                '/devices/',
                `d`.`id`) AS `url`
    FROM
        ((`devices` `d`
        LEFT JOIN `organizations` `o` ON (`d`.`organization_id` = `o`.`id`))
        LEFT JOIN `device_statuses` `ds` ON (`d`.`device_status_id` = `ds`.`id`))
    ORDER BY `d`.`created_at` DESC
