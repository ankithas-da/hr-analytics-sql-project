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
  Q21  What is the attrition rate (%) of each department?
  Q48  Calculate each active employee's compa-ratio and bucket employees
       into under-paid, fairly paid and over-paid.
  Q54  For each department, how many employees left within 12 months of
       joining?
  Q58  Build a flight-risk list: high performers with low engagement who
       are paid below their role midpoint.
  Q63  Build a departmental recruitment funnel from applications to hires.
  Q69  Build a department scorecard with a risk rank.


KEY INSIGHTS
------------
1. Attrition is 22.5% (270 of 1,200). Finance is highest at 24.7%.
   Recommendation: focus retention work on Finance and Procurement. (Q21, Q46)

2. "Better Career Opportunity" is the top exit reason (34%), then
   Compensation (16%).
   Recommendation: build visible career paths and review pay bands. (Q23)

3. 46% of leavers quit within 12 months of joining.
   Recommendation: redesign onboarding and add a 90-day check-in. (Q24, Q54)

4. LinkedIn hires have the best 1-year retention (96.7%); Company Website
   hires have the worst (89.5%).
   Recommendation: shift hiring budget towards higher-retention channels.
   (Q36, Q62)

5. Promoted employees leave less often: 18.3% vs 23.0%.
   Recommendation: make promotion timelines predictable. (Q66)

6. Training shows no measurable performance lift (scores flat at about 3.4).
   Recommendation: review L&D programs for impact. (Q67)

7. 24 active employees are high-performing, disengaged and paid below their
   role midpoint.
   Recommendation: start stay conversations with them first. (Q58)


HOW TO RUN
----------
Requirements: MySQL 8.0 or newer (window functions and CTEs are used).
Check your version with: SELECT VERSION();

Step 1. Load the data.
  In MySQL Workbench: File > Open SQL Script, choose
  sql/01_create_and_load_database.sql, then click the lightning bolt.
  Or from the command line:
    mysql -u root -p < sql/01_create_and_load_database.sql

Step 2. Select the database:
    USE hr_analytics;

Step 3. Open sql/02_hr_analytics_queries_mysql.sql and run one query at a
  time (select it, then press Ctrl+Enter). Each query header shows the
  business problem, the tables used and the number of rows you should get,
  so you can check your result.

PostgreSQL users: replace DATEDIFF(a, b) with (a::date - b::date) and
YEAR(x) with EXTRACT(YEAR FROM x::date).


DASHBOARDS
----------
Two dashboards were designed on the same data with different objectives:

1. Attrition & Retention Command Center (Power BI)
   Who is leaving, why, how early, and who is next.

2. Talent Acquisition Performance (Tableau)
   Where hiring is slow or leaky, and which sources deliver quality hires.

The full build guide (data model, measures, every visual and its fields) is
in docs/Dashboard_Build_Guide_PowerBI_Tableau.md.
Dashboard files and screenshots go in the dashboards/ folder.


DATA NOTES AND ASSUMPTIONS
--------------------------
- Attrition = employment_status is not 'Active' (Resigned + Terminated).
- employees.current_salary equals each employee's joining salary, so
  salary-based answers reflect starting pay. Latest pay is in
  salary_history (Q51 audits the mismatch: 810 of 1,200 records).
- Hires = applications with status 'Hired' (588). Accepted offers (716) are
  higher, so the last funnel stage in Q63 does not shrink strictly.
- Replacement cost in Q56 assumes 50% of annual salary. Change the 0.5
  factor to match your policy.


SKILLS DEMONSTRATED
-------------------
SQL (joins, aggregation, CTEs, window functions, cohort analysis,
data-quality checks), HR analytics (attrition, pay equity, recruitment
funnel), business storytelling, Power BI and Tableau dashboard design.


ABOUT
-----
Author:  Ankita (Ankitha_S) Shinde 
Contact: www.linkedin.com/in/ankithas-dataanalyst


