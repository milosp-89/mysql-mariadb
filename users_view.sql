CREATE ALGORITHM=UNDEFINED DEFINER=`user`@`%` SQL SECURITY DEFINER
VIEW `users_monitoring_view` AS
WITH user_data AS (
    SELECT
        `uru`.`user_id` AS `user_id`,
        `ur`.`name` AS `role_name`,
        `ur`.`organization_id` AS `organization_id`,
        `u`.`email` AS `email`,
        `u`.`last_sign_in_at` AS `last_sign_in_at`,
        `u`.`active` AS `active`,
        `u`.`created_at` AS `created_at`,
        `u`.`updated_at` AS `updated_at`,
        `u`.`sign_in_count` AS `sign_in_count`
    FROM
        (`user_roles_users` `uru`
        LEFT JOIN `user_roles` `ur` ON `uru`.`user_role_id` = `ur`.`id`)
        LEFT JOIN `users` `u` ON `uru`.`user_id` = `u`.`id`
)
SELECT
    `ud`.`user_id` AS `user_id`,
    `ud`.`active` AS `active`,
    `ud`.`created_at` AS `created_at`,
    `ud`.`updated_at` AS `updated_at`,
    `ud`.`sign_in_count` AS `sign_in_count`,
    `ud`.`role_name` AS `role_name`,
    `ud`.`email` AS `email`,
    `ud`.`last_sign_in_at` AS `last_sign_in_at`,
    `ud`.`organization_id` AS `org_id`,
    `org`.`name` AS `org_name`
FROM
    (`user_data` `ud`
    LEFT JOIN `organizations` `org` ON `ud`.`organization_id` = `org`.`id`);
