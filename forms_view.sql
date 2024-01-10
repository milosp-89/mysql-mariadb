-- forms monitoring view

CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `user`@`%` 
    SQL SECURITY DEFINER
VIEW `forms_monitoring_view` AS
    SELECT 
        `f`.`id` AS `form_id`,
        `f`.`name` AS `name`,
        `f`.`description` AS `description`,
        `f`.`version` AS `version`,
        CASE
            WHEN `f`.`enabled` = 1 THEN 'Yes'
            ELSE 'No'
        END AS `enabled`,
        DATE_FORMAT(`f`.`created_at`, '%d-%m-%Y') AS `creation_date`,
        DATE_FORMAT(`f`.`updated_at`, '%d-%m-%Y') AS `update_date`,
        CASE
            WHEN `f`.`deleted_at` IS NOT NULL THEN 'Yes'
            ELSE 'No'
        END AS `is_deleted`,
        DATE_FORMAT(`f`.`deleted_at`, '%d-%m-%Y') AS `delete_date`,
        CAST(`f`.`deleted_at` AS TIME) AS `delete_time`,
        `f`.`organization_id` AS `org_id`,
        `org`.`name` AS `org_name`,
        `org`.`short_name` AS `account_name`,
        `f`.`destinations_count` AS `total_destinations`,
        `f`.`submissions_counter` AS `total_submissions`,
        CONCAT('www',
                `f`.`organization_id`,
                '/forms/',
                `f`.`id`) AS `url`
    FROM
        (`forms` `f`
        LEFT JOIN `organizations` `org` ON (`f`.`organization_id` = `org`.`id`))
    ORDER BY `f`.`created_at` DESC
