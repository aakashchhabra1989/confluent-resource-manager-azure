-- Populate Daily User Registration Count Sink Table
-- This SQL inserts daily user registration counts into the sink table

INSERT INTO tbl_${project_name}_daily_user_registration_sink 
SELECT 
  registration_date,
  user_count,
  CURRENT_TIMESTAMP as calculation_timestamp
FROM vw_${project_name}_daily_user_registrations;
