-- organizaion monitoring view

CREATE ALGORITHM=UNDEFINED DEFINER=`user`@`%` SQL SECURITY DEFINER 
VIEW `organizations_monitoring_view` AS 
    WITH total_count AS (
        SELECT 
            `pending_submissions`.`organization_id` AS `org_id`,
            COUNT(`pending_submissions`.`id`) AS `total_submissions`
        FROM 
            `pending_submissions` 
        GROUP BY 
            `pending_submissions`.`organization_id`
    ), 
    latest_date AS (
        SELECT 
            `forms`.`organization_id` AS `org_id`,
            MAX(CAST(`forms`.`updated_at` AS DATE)) AS `last_update`
        FROM 
            `forms` 
        GROUP BY 
            `forms`.`organization_id`
    )
    SELECT 
        `o`.`id` AS `org_id`,
        `o`.`name` AS `name`,
        `o`.`short_name` AS `account_name`,
        DATE_FORMAT(`o`.`created_at`, '%d-%m-%Y') AS `date_of_creation`,
        `o`.`state` AS `type`,
        CASE 
            WHEN `o`.`deleted_at` IS NULL THEN 'No'
            ELSE 'Yes' 
        END AS `is_deleted`,
        DATE_FORMAT(`o`.`deleted_at`, '%d-%m-%Y') AS `deleted_date`,
        `o`.`forms_count` AS `total_forms`,
        `o`.`assigned_devices_count` AS `total_devices`,
        `o`.`resources_count` AS `total_resources`,
        `tc`.`total_submissions` AS `total_submissions`,
        DATE_FORMAT(`ld`.`last_update`, '%d-%m-%Y') AS `date_of_last_submission`,
        CONCAT('www', `o`.`id`) AS `url`
    FROM 
        ((`organizations` `o` 
            LEFT JOIN `total_count` `tc` ON (`o`.`id` = `tc`.`org_id`))
            LEFT JOIN `latest_date` `ld` ON (`o`.`id` = `ld`.`org_id`))
    ORDER BY 
        `o`.`created_at` DESC;
