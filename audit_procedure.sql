-- stored procedure for auditing changes on forms

DELIMITER $$
	
CREATE DEFINER=`user`@`%` PROCEDURE `form_edit_audit`(in dm_form_id int)
begin
	select  u.email user_email,
			el.message as edit_message,
			el.created_at as edit_created_on,
			el.extra_info edit_message_extra_info
	from event_logs as el
	left join 
			users as u on el.user_id = u.id
	where el.target_type = 'Form' and el.target_id = dm_form_id
    order by edit_created_on desc;
end$$
	
DELIMITER;
