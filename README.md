HR ANALYTICS SQL PROJECT
========================

69 SQL questions (Easy, Intermediate, Advanced) that solve real HR business
problems on a 24-table employee database: attrition, pay equity, hiring
funnel, performance, training, benefits, engagement and attendance.

Every question is written as a business request, for example "The CHRO wants
to know the biggest drivers of exits", followed by the SQL that answers it.


BUSINESS PROBLEM
----------------
A mid-sized Indian company with 1,200 employees, 8 departments and 8 cities
has a 22.5% attrition rate, slow hiring and no single view of its people
data. As the People Analytics analyst, I answer the questions sent by the
CHRO, Finance, Talent Acquisition, L&D and department heads, and turn the
results into actions.


DATASET
-------
24 tables, 73,106 rows. Hires from Jan 2021 to Nov 2025. As-of date:
31-Dec-2025. Salaries are annual, in INR.

Workforce core:
  employees, departments, job_roles, locations, salary_grades, salary_history
Attrition:
  employee_exit_details, exit_reasons
Recruitment:
  job_requisitions, candidates, job_applications, interviews, job_offers
Performance and L&D:
  performance_reviews, promotions, training_programs, employee_training
Engagement and attendance:
  engagement_surveys, survey_questions, attendance_monthly
Benefits and onboarding:
  benefits, employee_benefits, onboarding
Summary table:
  employee_analytics_master (one flat row per employee)

The full schema (columns, keys, relationships, allowed values) is documented
at the top of sql/02_hr_analytics_queries_mysql.sql.


REPOSITORY STRUCTURE
--------------------
data/
  24 source CSV files
sql/
  01_create_and_load_database.sql    creates the database, tables and all data
  02_hr_analytics_queries_mysql.sql  all 69 queries with schema docs (MySQL 8+)
  sqlite_version/                    same queries with SQLite-style dates
docs/
  HR_Analytics_SQL_Project.md        project write-up with all solutions
  Dashboard_Build_Guide_PowerBI_Tableau.md
dashboards/
  Power BI and Tableau files and screenshots


QUESTIONS AT A GLANCE
---------------------
Easy (Q1-Q20)
  SELECT, WHERE, GROUP BY, ORDER BY, simple JOIN, CASE

Intermediate (Q21-Q45)
  Multi-table joins, rates and percentages, self-join, SUM() OVER (),
  date arithmetic

Advanced (Q46-Q69)
  CTEs, RANK, ROW_NUMBER, LAG, NTILE, PERCENT_RANK, cohort logic,
  data-quality audits, risk lists, scorecards

Example questions:
  Q21  What is the attrition rate (%) of each
