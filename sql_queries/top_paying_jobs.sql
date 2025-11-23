/*
 What are the top paying jobs for my role 
 - Identify the top 10 highest paying Data roles that are available in your location 
 - Focus on job postings with specified salaries
 - Why? Aims to highlight the top paying opportunities for Data Analyst, offering insights into employment location and location flexibilty 
 */
SELECT job_id,
    company_dim.name As Company_name,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM job_postings_fact
    LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE job_title_short = 'Data Engineer'
    AND job_location = 'Anywhere'
    AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;