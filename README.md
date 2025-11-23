# 🚀 Introduction

Analysis of the data engineer job market in 2023! This project explores **top-paying jobs**, **in-demand skills**, and identifies where **high demand meets high salary** for Data Engineer roles.

* SQL queries can be found here: [sql_queries](./sql_queries/)
* Results of each SQL query are here: [sql_results_json](./sql_results_json/)
* Data sourced from [Luke Barousse](https://github.com/lukebarousse/SQL_Project_Data_Job_Analysis)

---

## 📚 Background

Inspired by the SQL course taught by [@Luke Barousse](https://github.com/lukebarousse), I explored the Data Engineer job market to identify **top-paid roles** and **high-demand skills**, building on existing work to find optimal job opportunities.

### 📝 Questions answered with SQL Queries:

1. What are the top-paying Data Engineer jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in-demand for Data Engineers?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

---

## 🛠 Tools Used

Several tools were used to analyze the Data Engineer job market:

- **SQL** – backbone of analysis for querying the database and deriving insights
- **PostgreSQL** – database management system
- **Jupyter Notebook (Python)** – for data visualization using **Pandas**, **NumPy**, and **Matplotlib**
- **Visual Studio Code** – for executing SQL queries and running Python code
- **Git & GitHub** – version control, project tracking, and sharing the analysis

---

## 📊 Analysis

### 1️⃣ Top Paying Data Engineer Jobs

To extract the highest-paying roles, I filtered Data Engineer positions by **average yearly salary** and **location**, focusing on remote jobs.

```sql
SELECT job_id,
       company_dim.name AS Company_name,
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
```

**Breakdown:**

- **Salary Range:** $242K – $325K per annum
- **Job Title Variety:** Roles vary from Data Engineer to Director of Engineering, reflecting diverse specializations
- **Employers:** Companies like Engtal, Durlston Partners, and Twitch offer the highest salaries

![Bar graph of top salaries for data engineers](./plots/median_salary.png)
*Bar graph visualising the median salary for the top salaries for data engineers.*

---

### 2️⃣ Skills for Top-Paying Jobs

Joined top-paying jobs with skills data to identify what employers value most:

```sql
WITH top_paying_jobs AS (
    SELECT job_id,
           company_dim.name AS Company_name,
           job_title,
           salary_year_avg
    FROM job_postings_fact
    LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
    WHERE job_title_short = 'Data Engineer'
      AND job_location = 'Anywhere'
      AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)
SELECT top_paying_jobs.*,
       skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;
```

**Key Skills Observed:**

- **Python** – count: 7
- **Spark** – count: 6
- Other skills show varying demand levels

![Bar graph of top salaries skills count](./plots/skill_count.png)
*Bar graph visualising the count of skills for the top paying jobs for data engineers.*

---

### 3️⃣ In-Demand Skills for Data Engineers

```sql
SELECT skills,
       COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Engineer'
  AND job_work_from_home = TRUE
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 10;
```

**Breakdown:**

- **SQL** and **Python** are essential for strong data processing skills
- **Azure**, **AWS**, **Spark** are critical for cloud-based data processing, big data analytics, and distributed computing

| Skills | Demand Count |
| ------ | ------------ |
| SQL    | 14213        |
| Python | 13893        |
| AWS    | 8570         |
| Azure  | 6997         |
| Spark  | 6612         |

_Top 5 most in-demand skills for Data Engineer jobs._

---

### 4️⃣ Skills Based on Salary

```sql
SELECT ROUND(AVG(salary_year_avg), 0) AS avg_salary,
       skills
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Engineer'
  AND salary_year_avg IS NOT NULL
  AND job_work_from_home = TRUE
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 10;
```

**Breakdown:**

- **Assembly** and **Mongo** – top-paying skills; Assembly for low-level systems, MongoDB for NoSQL
- **Ggplot2**, **Rust**, **Clojure**, **Julia** – high-performance computing, functional programming, and visualization
- **Perl** and **Solidity** – automation, scripting, smart contracts
- **Neo4j** and **GraphQL** – graph databases and API querying

| Skills   | Average Salary ($) |
| -------- | ------------------ |
| Assembly | 192,500            |
| Mongo    | 182,223            |
| Ggplot2  | 176,250            |
| Rust     | 172,819            |
| Clojure  | 170,867            |
| Perl     | 169,000            |
| Neo4j    | 166,559            |
| Solidity | 166,250            |
| GraphQL  | 162,547            |
| Julia    | 160,500            |

*Table of the average salary for the top paying skills for data engineers*

---

### 5️⃣ Most Optimal Skills to Learn

```sql
SELECT skills_dim.skill_id,
       skills_dim.skills,
       COUNT(skills_job_dim.job_id) AS demand_count,
       ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Engineer'
  AND salary_year_avg IS NOT NULL
  AND job_work_from_home = TRUE
GROUP BY skills_dim.skill_id
HAVING COUNT(skills_job_dim.job_id) > 10
ORDER BY avg_salary DESC,
         demand_count DESC
LIMIT 10;
```

| Skills        | Demand Count | Average Salary ($) |
| ------------- | ------------ | ------------------ |
| Kubernetes    | 56           | 158,190            |
| Numpy         | 14           | 157,592            |
| Cassandra     | 19           | 151,282            |
| Kafka         | 134          | 150,549            |
| Golang        | 11           | 147,818            |
| Terraform     | 44           | 146,057            |
| Pandas        | 38           | 144,656            |
| Elasticsearch | 21           | 144,102            |
| Ruby          | 14           | 144,000            |

*Table of the most optimal skills for data engineers sorted by salary*

**Breakdown:**

- **Cloud & Infrastructure:** Kubernetes and Terraform highlight the value of cloud orchestration and infrastructure-as-code
- **Data Processing & Streaming:** Kafka and Cassandra show demand for distributed data pipelines
- **Programming & Data Manipulation:** Numpy, Pandas, and Golang for ETL and high-performance backend work
- **Search & Analytics:** Elasticsearch for analytics and logging
- **Other Languages:** Ruby shows niche usage for automation/legacy systems

---

## 🎯 Key Learnings

- Implemented merging tables and subqueries using `WITH` clauses
- Aggregated data using `GROUP BY`, `COUNT()`, and `AVG()`
- Derived insights from SQL queries using Python

---

## ✅ Conclusions

1. **Top-Paying Jobs:** Highest-paying remote Data Engineer roles offer salaries up to $325,000
2. **Skills for Top-Paying Jobs:** Python is critical for high-paying roles
3. **Most In-Demand Skills:** SQL is essential across the market
4. **Skills with Higher Salaries:** Assembly and MongoDB offer premium compensation for niche expertise
5. **Optimal Skills for Market Value:** Kubernetes leads in demand and salary, making it strategic to learn

---

## 💡 Closing Thoughts

This project strengthened my SQL and Python skills and provided insights into the Data Engineer job market. By focusing on high-demand, high-salary skills, aspiring Data Engineers can better position themselves in a competitive job market. Continuous learning and adaptation remain key to success in this field.
