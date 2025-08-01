-- Daily User Registration Count Stream Processing for Azure
-- This SQL creates a view counting users registered on each particular date

CREATE VIEW vw_${project_name}_${sub_environment}_daily_user_registrations AS
SELECT 
  registration_date_only as registration_date,
  COUNT(DISTINCT id) as user_count
FROM tbl_${project_name}_${sub_environment}_user_profiles_source
GROUP BY registration_date_only;
