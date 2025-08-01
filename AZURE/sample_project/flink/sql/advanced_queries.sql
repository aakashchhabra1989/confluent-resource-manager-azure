-- Advanced User Registration Analysis Examples for Azure
-- Collection of more complex SQL statements for user registration analytics

-- 1. Create sink table for daily registration counts
CREATE TABLE tbl_${project_name}_${sub_environment}_daily_registration_sink (
  registration_date STRING,
  user_count BIGINT,
  calculation_timestamp TIMESTAMP(3)
) WITH (
  'connector' = 'confluent-kafka',
  'topic' = '${topic_prefix}.${sub_environment}.${project_name}.daily_user_registration_counts.0',
  'value.format' = 'json'
);

-- 2. Insert daily registration counts into sink
INSERT INTO tbl_${project_name}_${sub_environment}_daily_registration_sink 
SELECT registration_date, user_count, CURRENT_TIMESTAMP as calculation_timestamp
FROM vw_${project_name}_${sub_environment}_daily_user_registrations;

-- 3. Real-time recent registrations view (last 24 hours)
CREATE VIEW vw_${project_name}_recent_registrations AS
SELECT registration_date_only, COUNT(DISTINCT id) as users_today
FROM tbl_${project_name}_user_profiles_source
WHERE registrationDate > CURRENT_TIMESTAMP - INTERVAL '24' HOUR
GROUP BY registration_date_only;

-- 4. Weekly registration trend analysis
CREATE VIEW vw_${project_name}_weekly_registration_trend AS
SELECT 
  DATE_FORMAT(registrationDate, 'yyyy-ww') as week_year,
  COUNT(DISTINCT id) as weekly_user_count
FROM tbl_${project_name}_user_profiles_source
GROUP BY DATE_FORMAT(registrationDate, 'yyyy-ww');

-- 5. Monthly registration summary
CREATE VIEW vw_${project_name}_monthly_registration_summary AS
SELECT 
  DATE_FORMAT(registrationDate, 'yyyy-MM') as month_year,
  COUNT(DISTINCT id) as monthly_user_count,
  COUNT(DISTINCT CASE WHEN email IS NOT NULL THEN id END) as users_with_email
FROM tbl_${project_name}_user_profiles_source
GROUP BY DATE_FORMAT(registrationDate, 'yyyy-MM');
