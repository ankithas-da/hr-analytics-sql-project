#============================================================#
#                 HR ANALYTICS SQL PROJECT                   #
#============================================================#

 #====================== EASY ======================#
USE HR;
#Q1  Workforce Overview
#Problem : The CHRO wants a one-line snapshot of the workforce for the board deck.
#Question: What is the total number of employees, and how many are Active, Resigned and Terminated?

select * from employees;

SELECT COUNT(*) AS total_employees,
       SUM(CASE WHEN employment_status = 'Active' THEN 1 ELSE 0 END)     AS active,
       SUM(CASE WHEN employment_status = 'Resigned' THEN 1 ELSE 0 END)   AS resigned,
       SUM(CASE WHEN employment_status = 'Terminated' THEN 1 ELSE 0 END) AS terminate
FROM employees;
#============================================================#

 #Q2  Workforce Overview
 #Problem : Department heads are asking how large their teams are.
 #Question: What is the total and active headcount of each department?
 
SELECT d.department_name,
       COUNT(*) AS total_employees,
       SUM(CASE WHEN e.employment_status = 'Active' THEN 1 ELSE 0 END) AS active_employees
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY total_employees DESC;
#============================================================#

#Q3  Workforce Overview
#Problem : The D&I committee needs the current gender mix.
#Question: What is the gender split (count and %) of active employees?

SELECT gender,
       COUNT(*) AS active_employees,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM employees WHERE employment_status = 'Active'), 1) AS pct_share
FROM employees
WHERE employment_status = 'Active'
GROUP BY gender;
#============================================================#

 #Q4  Workforce Overview
 #Problem : Facilities and admin want to plan office space by location.
 #Question: How many active employees work in each city?
 
SELECT l.city, l.state, COUNT(*) AS active_employees
FROM employees e
JOIN locations l ON e.location_id = l.location_id
WHERE e.employment_status = 'Active'
GROUP BY l.city, l.state
ORDER BY active_employees DESC;
#============================================================#

#Q5  Compensation
#Problem : Finance is building the annual payroll budget.
#Question: What are the average, minimum, maximum and total salary of active employees?

SELECT ROUND(AVG(current_salary), 0) AS avg_salary,
       MIN(current_salary) AS min_salary,
       MAX(current_salary) AS max_salary,
       SUM(current_salary) AS total_annual_payroll
FROM employees
WHERE employment_status = 'Active';
#============================================================#

 #Q6  Compensation
 #Problem : HR needs a clean reference sheet of all job roles and their pay bands.
 #Question: List every job role with its department, job family and salary range (min to max).

SELECT d.department_name, jr.role_name, jr.job_family, jr.salary_min, jr.salary_max
FROM job_roles jr
JOIN departments d ON jr.department_id = d.department_id
ORDER BY d.department_name, jr.salary_min;
#============================================================#

 #Q7  Workforce Overview
 #Problem : Leadership wants to see how fast the company has been growing.
 #Question: How many employees were hired in each year?

SELECT SUBSTR(hire_date, 1, 4) AS hire_year, COUNT(*) AS employees_hired
FROM employees
GROUP BY SUBSTR(hire_date, 1, 4)
ORDER BY hire_year;
#============================================================#

 #Q8  Compensation
 #Problem : The compensation team reviews top earners every year.
 #Question: Who are the 10 highest-paid active employees (with department and role)?

SELECT e.employee_id, e.employee_name, d.department_name, jr.role_name, e.current_salary
FROM employees e
JOIN departments d  ON e.department_id = d.department_id
JOIN job_roles jr   ON e.role_id = jr.role_id
WHERE e.employment_status = 'Active'
ORDER BY e.current_salary DESC
LIMIT 10;
#============================================================#

 #Q9  Recruitment
 #Problem : Talent Acquisition wants to know which channels bring in employees.
 #Question: How many employees came from each recruitment source?

SELECT recruitment_source, COUNT(*) AS employees
FROM employees
GROUP BY recruitment_source
ORDER BY employees DESC;
#============================================================#

 #Q10  Workforce Overview
 #Problem : L&D is planning upskilling programs based on qualifications.
 #Question: What is the education-level distribution of active employees?

SELECT education_level, COUNT(*) AS active_employees
FROM employees
WHERE employment_status = 'Active'
GROUP BY education_level
ORDER BY active_employees DESC;
#============================================================#

 #Q11  Attrition
 #Problem : The exit-interview team reports to leadership every quarter.
 #Question: What are the exit reasons, ordered by number of employees who left for that reason?

SELECT r.exit_reason, COUNT(*) AS exits
FROM employee_exit_details x
JOIN exit_reasons r ON x.exit_reason_id = r.exit_reason_id
GROUP BY r.exit_reason
ORDER BY exits DESC;
#============================================================#

 #Q12  Attrition
 #Problem : HR wants to know how many leavers the company would not take back.
 #Question: How many exited employees were marked 'would not rehire' versus 'would rehire'?

SELECT would_rehire, COUNT(*) AS exited_employees
FROM employee_exit_details
GROUP BY would_rehire;
#============================================================#

 #Q13  Benefits
 #Problem : The benefits manager is reviewing the cost of each benefit plan.
 #Question: List all benefits with their category and annual cost per employee, most expensive first.

SELECT benefit_name, benefit_category, annual_cost_per_employee
FROM benefits
ORDER BY annual_cost_per_employee DESC;
#============================================================#

 #Q14  Talent Mobility
 #Problem : Management wants to understand why people are being promoted.
 #Question: How many promotions happened for each promotion reason?

SELECT promotion_reason, COUNT(*) AS promotions
FROM promotions
GROUP BY promotion_reason
ORDER BY promotions DESC;
#============================================================#

 #Q15  Performance
 #Problem : The annual performance cycle for 2025 has closed.
 #Question: What is the distribution of performance ratings in 2025?

SELECT performance_rating, COUNT(*) AS employees
FROM performance_reviews
WHERE review_year = 2025
GROUP BY performance_rating
ORDER BY employees DESC;
#============================================================#

 #Q16  Recruitment
 #Problem : The hiring dashboard needs the state of open vacancies.
 #Question: How many requisitions are Open vs Closed, and how many positions does each represent?

SELECT requisition_status, COUNT(*) AS requisitions, SUM(positions_count) AS total_positions
FROM job_requisitions
GROUP BY requisition_status;
#============================================================#

 #Q17  Recruitment
 #Problem : Recruiters want to know how many job offers actually get accepted.
 #Question: How many offers were Accepted versus Declined?

SELECT offer_status, COUNT(*) AS offers
FROM job_offers
GROUP BY offer_status;
#============================================================#

 #Q18  Learning & Development
 #Problem : L&D is reviewing its training catalogue before budget approval.
 #Question: List all training programs ordered by cost per employee (highest first), with duration.

SELECT training_name, training_category, duration_hours, cost_per_employee
FROM training_programs
ORDER BY cost_per_employee DESC;
#============================================================#

 #Q19  Onboarding
 #Problem : HR operations needs to chase pending onboarding paperwork.
 #Question: How many employees have Completed vs Pending onboarding, and how many have unverified documents?

SELECT onboarding_status,
       COUNT(*) AS employees,
       SUM(CASE WHEN documents_verified = 'No' THEN 1 ELSE 0 END) AS documents_not_verified
FROM onboarding
GROUP BY onboarding_status;
#============================================================#

 #Q20  Engagement
 #Problem : The engagement committee wants the headline survey result per theme.
 #Question: What is the average engagement score for each survey category?

SELECT q.survey_category, q.question_text, ROUND(AVG(s.score), 2) AS avg_score
FROM engagement_surveys s
JOIN survey_questions q ON s.question_id = q.question_id
GROUP BY q.survey_category, q.question_text
ORDER BY avg_score DESC;


 #====================== INTERMEDIATE ======================#

 #Q21 [Intermediate] Attrition
 #Problem : Which departments are losing people fastest?
 #Question: What is the attrition rate (%) of each department?

SELECT d.department_name,
       COUNT(*) AS total_employees,
       SUM(CASE WHEN e.employment_status <> 'Active' THEN 1 ELSE 0 END) AS leavers,
       ROUND(100.0 * SUM(CASE WHEN e.employment_status <> 'Active' THEN 1 ELSE 0 END) / COUNT(*), 1) AS attrition_pct
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY attrition_pct DESC;
#============================================================#

 #Q22 [Intermediate] Attrition
 #Problem : Leadership suspects some cities have a retention problem.
 #Question: What is the attrition rate (%) by city?

SELECT l.city,
       COUNT(*) AS total_employees,
       SUM(CASE WHEN e.employment_status <> 'Active' THEN 1 ELSE 0 END) AS leavers,
       ROUND(100.0 * SUM(CASE WHEN e.employment_status <> 'Active' THEN 1 ELSE 0 END) / COUNT(*), 1) AS attrition_pct
FROM employees e
JOIN locations l ON e.location_id = l.location_id
GROUP BY l.city
ORDER BY attrition_pct DESC;
#============================================================#

 #Q23 [Intermediate] Attrition
 #Problem : The CHRO wants to know the biggest drivers of exits.
 #Question: What share (%) of all exits does each exit reason account for?

SELECT r.exit_reason,
       COUNT(*) AS exits,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_exits
FROM employee_exit_details x
JOIN exit_reasons r ON x.exit_reason_id = r.exit_reason_id
GROUP BY r.exit_reason
ORDER BY exits DESC;
#============================================================#

 #Q24 [Intermediate] Attrition
 #Problem : Are we retaining people long enough to recover hiring costs?
 #Question: What is the average tenure (years) of leavers vs. active employees in each department?

SELECT department_name,
       ROUND(AVG(CASE WHEN attrition_flag = 1 THEN tenure_years END), 2) AS avg_tenure_leavers,
       ROUND(AVG(CASE WHEN attrition_flag = 0 THEN tenure_years END), 2) AS avg_tenure_active
FROM employee_analytics_master
GROUP BY department_name
ORDER BY avg_tenure_leavers;
#============================================================#

 #Q25 [Intermediate] Attrition
 #Problem : The exit-interview programme is only valuable if people actually complete it.
 #Question: What is the exit-interview completion rate for each exit reason?

SELECT r.exit_reason,
       COUNT(*) AS exits,
       SUM(CASE WHEN x.exit_interview_completed = 'Yes' THEN 1 ELSE 0 END) AS interviews_completed,
       ROUND(100.0 * SUM(CASE WHEN x.exit_interview_completed = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS completion_pct
FROM employee_exit_details x
JOIN exit_reasons r ON x.exit_reason_id = r.exit_reason_id
GROUP BY r.exit_reason
ORDER BY completion_pct;
#============================================================#

 #Q26 [Intermediate] Attrition
 #Problem : Are certain departments' managers rated poorly by people who leave?
 #Question: What is the average manager rating given by leavers in each department?

SELECT d.department_name,
       COUNT(*) AS exits,
       ROUND(AVG(x.manager_rating), 2) AS avg_manager_rating
FROM employee_exit_details x
JOIN employees e   ON x.employee_id = e.employee_id
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY avg_manager_rating;
#============================================================#

 #Q27 [Intermediate] Compensation
 #Problem : A pay-equity review has been requested by the board.
 #Question: What is the average salary of active male vs. female employees in each department?

SELECT d.department_name,
       ROUND(AVG(CASE WHEN e.gender = 'Male'   THEN e.current_salary END), 0) AS avg_salary_male,
       ROUND(AVG(CASE WHEN e.gender = 'Female' THEN e.current_salary END), 0) AS avg_salary_female
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.employment_status = 'Active'
GROUP BY d.department_name
ORDER BY d.department_name;
#============================================================#

 #Q28 [Intermediate] Compensation
 #Problem : Employees sitting right at the bottom of their role's pay band are the most likely to feel under-valued.
 #Question: Which active employees earn within 10% of the minimum of their role's salary band? Show how far above the minimum they are.

SELECT e.employee_id, e.employee_name, jr.role_name,
       e.current_salary, jr.salary_min,
       ROUND(100.0 * (e.current_salary - jr.salary_min) / jr.salary_min, 1) AS pct_above_band_min
FROM employees e
JOIN job_roles jr ON e.role_id = jr.role_id
WHERE e.employment_status = 'Active'
  AND e.current_salary <= jr.salary_min * 1.10
ORDER BY pct_above_band_min, e.employee_id
LIMIT 20;
#============================================================#

 #Q29 [Intermediate] Compensation
 #Problem : Salary grades define the company's pay structure; employees outside it need review.
 #Question: Validation check: how many active employees in each grade are paid below the grade minimum or above the grade maximum? (0 is the healthy result.)

SELECT sg.grade_code,
       COUNT(*) AS active_employees,
       SUM(CASE WHEN e.current_salary < sg.min_salary THEN 1 ELSE 0 END) AS below_grade_min,
       SUM(CASE WHEN e.current_salary > sg.max_salary THEN 1 ELSE 0 END) AS above_grade_max
FROM employees e
JOIN salary_grades sg ON e.grade_id = sg.grade_id
WHERE e.employment_status = 'Active'
GROUP BY sg.grade_code
ORDER BY sg.grade_code;
#============================================================#

 #Q30 [Intermediate] Compensation
 #Problem : What is the typical raise employees get for each type of salary change?
 #Question: How many salary revisions happened for each change reason, and what is the average resulting salary?

SELECT change_reason, COUNT(*) AS revisions, ROUND(AVG(annual_salary), 0) AS avg_salary_after_change
FROM salary_history
GROUP BY change_reason
ORDER BY revisions DESC;
#============================================================#

 #Q31 [Intermediate] Performance
 #Problem : Which departments perform best, and is performance improving?
 #Question: What is the average performance score per department for each review year?

SELECT d.department_name, p.review_year, ROUND(AVG(p.performance_score), 2) AS avg_score
FROM performance_reviews p
JOIN employees e   ON p.employee_id = e.employee_id
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name, p.review_year
ORDER BY d.department_name, p.review_year;
#============================================================#

 #Q32 [Intermediate] Learning & Development
 #Problem : L&D must prove its programs are actually being finished.
 #Question: What is the completion rate and average score of each training program?

SELECT tp.training_name, tp.training_category,
       COUNT(*) AS enrolments,
       SUM(CASE WHEN et.completion_status = 'Completed' THEN 1 ELSE 0 END) AS completed,
       ROUND(100.0 * SUM(CASE WHEN et.completion_status = 'Completed' THEN 1 ELSE 0 END) / COUNT(*), 1) AS completion_pct,
       ROUND(AVG(et.score), 2) AS avg_score
FROM employee_training et
JOIN training_programs tp ON et.training_id = tp.training_id
GROUP BY tp.training_name, tp.training_category
ORDER BY completion_pct DESC;
#============================================================#

 #Q33 [Intermediate] Learning & Development
 #Problem : Finance wants to allocate the training budget to departments.
 #Question: How much has been spent on completed training in each department?

SELECT d.department_name,
       COUNT(*) AS completed_trainings,
       SUM(tp.cost_per_employee) AS total_training_cost
FROM employee_training et
JOIN training_programs tp ON et.training_id = tp.training_id
JOIN employees e          ON et.employee_id = e.employee_id
JOIN departments d        ON e.department_id = d.department_id
WHERE et.completion_status = 'Completed'
GROUP BY d.department_name
ORDER BY total_training_cost DESC;
#============================================================#

 #Q34 [Intermediate] Benefits
 #Problem : The benefits budget must be forecast for next year.
 #Question: How many active enrolments does each benefit have, and what is its total annual cost?

SELECT b.benefit_name, b.benefit_category,
       COUNT(*) AS active_enrolments,
       COUNT(*) * b.annual_cost_per_employee AS total_annual_cost
FROM employee_benefits eb
JOIN benefits b ON eb.benefit_id = b.benefit_id
WHERE eb.benefit_status = 'Active'
GROUP BY b.benefit_name, b.benefit_category, b.annual_cost_per_employee
ORDER BY total_annual_cost DESC;
#============================================================#

 #Q35 [Intermediate] Recruitment
 #Problem : Talent Acquisition wants a view of where candidates fall out of the process.
 #Question: How many job applications are in each application status, and what % of the total is that?

SELECT application_status,
       COUNT(*) AS applications,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_applications
FROM job_applications
GROUP BY application_status
ORDER BY applications DESC;
#============================================================#

 #Q36 [Intermediate] Recruitment
 #Problem : Which recruitment channel is worth the money?
 #Question: For each recruitment source, how many applications were made and what % ended in a hire?

SELECT c.recruitment_source,
       COUNT(*) AS applications,
       SUM(CASE WHEN a.application_status = 'Hired' THEN 1 ELSE 0 END) AS hires,
       ROUND(100.0 * SUM(CASE WHEN a.application_status = 'Hired' THEN 1 ELSE 0 END) / COUNT(*), 2) AS hire_conversion_pct
FROM job_applications a
JOIN candidates c ON a.candidate_id = c.candidate_id
GROUP BY c.recruitment_source
ORDER BY hire_conversion_pct DESC;
#============================================================#

 #Q37 [Intermediate] Recruitment
 #Problem : Are some interview stages scoring candidates very differently?
 #Question: What is the average interview score by interview type and result?

SELECT interview_type, interview_result,
       COUNT(*) AS interviews,
       ROUND(AVG(interview_score), 2) AS avg_score
FROM interviews
GROUP BY interview_type, interview_result
ORDER BY interview_type, avg_score DESC;
#============================================================#

 #Q38 [Intermediate] Recruitment
 #Problem : Candidates declining offers wastes recruiter time.
 #Question: What is the offer acceptance rate (%) for each department?

SELECT d.department_name,
       COUNT(*) AS offers_made,
       SUM(CASE WHEN o.offer_status = 'Accepted' THEN 1 ELSE 0 END) AS accepted,
       ROUND(100.0 * SUM(CASE WHEN o.offer_status = 'Accepted' THEN 1 ELSE 0 END) / COUNT(*), 1) AS acceptance_pct
FROM job_offers o
JOIN job_applications a  ON o.application_id = a.application_id
JOIN job_requisitions r  ON a.requisition_id = r.requisition_id
JOIN departments d       ON r.department_id = d.department_id
GROUP BY d.department_name
ORDER BY acceptance_pct DESC;
#============================================================#

 #Q39 [Intermediate] Recruitment
 #Problem : Hiring managers complain that vacancies stay open too long.
 #Question: What is the average time-to-fill (in days) of closed requisitions in each department?

SELECT d.department_name,
       COUNT(*) AS closed_requisitions,
       ROUND(AVG(DATEDIFF(r.closing_date, r.opening_date)), 1) AS avg_days_to_fill
FROM job_requisitions r
JOIN departments d ON r.department_id = d.department_id
WHERE r.requisition_status = 'Closed'
  AND r.closing_date IS NOT NULL
GROUP BY d.department_name
ORDER BY avg_days_to_fill DESC;
#============================================================#

 #Q40 [Intermediate] Attendance
 #Problem : Operations wants to find departments with high unplanned absence.
 #Question: What is the overall absenteeism % (absentee days / working days) of each department?

SELECT d.department_name,
       SUM(a.working_days)  AS total_working_days,
       SUM(a.absentee_days) AS total_absentee_days,
       ROUND(100.0 * SUM(a.absentee_days) / SUM(a.working_days), 2) AS absenteeism_pct
FROM attendance_monthly a
JOIN employees e   ON a.employee_id = e.employee_id
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY absenteeism_pct DESC;
#============================================================#

 #Q41 [Intermediate] Attendance
 #Problem : Management is designing a hybrid-work policy.
 #Question: What share (%) of working days is spent working from home, per department?

SELECT d.department_name,
       ROUND(100.0 * SUM(a.wfh_days) / SUM(a.working_days), 2) AS wfh_pct
FROM attendance_monthly a
JOIN employees e   ON a.employee_id = e.employee_id
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY wfh_pct DESC;
#============================================================#

 #Q42 [Intermediate] Engagement
 #Problem : Is employee sentiment improving year over year?
 #Question: What is the average engagement score per survey category for each survey year?

SELECT s.survey_year, q.survey_category, ROUND(AVG(s.score), 2) AS avg_score
FROM engagement_surveys s
JOIN survey_questions q ON s.question_id = q.question_id
GROUP BY s.survey_year, q.survey_category
ORDER BY q.survey_category, s.survey_year;
#============================================================#

 #Q43 [Intermediate] Talent Mobility
 #Problem : Which departments promote the most from within?
 #Question: How many promotions happened in each department, and what is that as a % of the department's headcount?

SELECT d.department_name,
       COUNT(DISTINCT p.promotion_id) AS promotions,
       COUNT(DISTINCT e.employee_id)  AS dept_headcount,
       ROUND(100.0 * COUNT(DISTINCT p.promotion_id) / COUNT(DISTINCT e.employee_id), 1) AS promotions_per_100_employees
FROM employees e
JOIN departments d ON e.department_id = d.department_id
LEFT JOIN promotions p ON e.employee_id = p.employee_id
GROUP BY d.department_name
ORDER BY promotions_per_100_employees DESC;
#============================================================#

 #Q44 [Intermediate] Onboarding
 #Problem : A slow onboarding process delays productivity.
 #Question: What is the average number of days to complete onboarding in each department?

SELECT d.department_name,
       COUNT(*) AS employees_onboarded,
       ROUND(AVG(DATEDIFF(o.onboarding_completion_date, o.joining_date)), 1) AS avg_days_to_complete
FROM onboarding o
JOIN employees e   ON o.employee_id = e.employee_id
JOIN departments d ON e.department_id = d.department_id
WHERE o.onboarding_completion_date IS NOT NULL
GROUP BY d.department_name
ORDER BY avg_days_to_complete DESC;
#============================================================#

 #Q45 [Intermediate] Workforce Overview
 #Problem : Large teams reporting to a single manager are a management-capacity risk.
 #Question: Which 10 managers have the most direct reports? (Use a self-join.)

SELECT m.employee_id AS manager_id, m.employee_name AS manager_name,
       COUNT(e.employee_id) AS direct_reports
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
GROUP BY m.employee_id, m.employee_name
ORDER BY direct_reports DESC, m.employee_id
LIMIT 10;

 #====================== INTERMEDIATE ======================#

 #Q46 [Advanced] Attrition
 #Problem : Executives want a ranked attrition league table.
 #Question: Rank departments by attrition rate using a CTE and a window function, and show how far each is from the company average.

WITH dept_attr AS (
    SELECT d.department_name,
           COUNT(*) AS headcount,
           SUM(CASE WHEN e.employment_status <> 'Active' THEN 1 ELSE 0 END) AS leavers
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    GROUP BY d.department_name
)
SELECT department_name, headcount, leavers,
       ROUND(100.0 * leavers / headcount, 1) AS attrition_pct,
       RANK() OVER (ORDER BY 1.0 * leavers / headcount DESC) AS attrition_rank,
       ROUND(100.0 * leavers / headcount
             - 100.0 * SUM(leavers) OVER () / SUM(headcount) OVER (), 1) AS pts_vs_company_avg
FROM dept_attr
ORDER BY attrition_rank;
 #============================================================#

 #Q47 [Advanced] Compensation
 #Problem : Compensation committee wants to benchmark each department's top earners.
 #Question: Find the top 3 highest-paid active employees in every department (ROW_NUMBER / PARTITION BY).

WITH ranked AS (
    SELECT d.department_name, e.employee_id, e.employee_name, jr.role_name, e.current_salary,
           ROW_NUMBER() OVER (PARTITION BY e.department_id ORDER BY e.current_salary DESC) AS rn
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN job_roles jr  ON e.role_id = jr.role_id
    WHERE e.employment_status = 'Active'
)
SELECT department_name, rn AS salary_rank, employee_name, role_name, current_salary
FROM ranked
WHERE rn <= 3
ORDER BY department_name, rn;
#============================================================#

 #Q48 [Advanced] Compensation
 #Problem : Compa-ratio (salary / band midpoint) is the standard way to judge if people are paid fairly for their role.
 #Question: Calculate each active employee's compa-ratio and bucket employees into Under-paid (<0.90), Fairly paid (0.90-1.10) and Over-paid (>1.10).

WITH compa AS (
    SELECT e.employee_id,
           1.0 * e.current_salary / ((jr.salary_min + jr.salary_max) / 2.0) AS compa_ratio
    FROM employees e
    JOIN job_roles jr ON e.role_id = jr.role_id
    WHERE e.employment_status = 'Active'
)
SELECT CASE WHEN compa_ratio < 0.90 THEN '1. Under-paid (<0.90)'
            WHEN compa_ratio <= 1.10 THEN '2. Fairly paid (0.90-1.10)'
            ELSE '3. Over-paid (>1.10)' END AS pay_position,
       COUNT(*) AS employees,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_active,
       ROUND(AVG(compa_ratio), 3) AS avg_compa_ratio
FROM compa
GROUP BY pay_position
ORDER BY pay_position;
#============================================================#

 #Q49 [Advanced] Compensation
 #Problem : Pay equity must be checked like-for-like, i.e. within the same role.
 #Question: For each role, compare average male and female salary and compute the gender pay gap % (only roles that have both genders).

WITH role_pay AS (
    SELECT jr.role_name,
           AVG(CASE WHEN e.gender = 'Male'   THEN e.current_salary END) AS avg_male,
           AVG(CASE WHEN e.gender = 'Female' THEN e.current_salary END) AS avg_female,
           SUM(CASE WHEN e.gender = 'Male'   THEN 1 ELSE 0 END) AS male_cnt,
           SUM(CASE WHEN e.gender = 'Female' THEN 1 ELSE 0 END) AS female_cnt
    FROM employees e
    JOIN job_roles jr ON e.role_id = jr.role_id
    WHERE e.employment_status = 'Active'
    GROUP BY jr.role_name
)
SELECT role_name, male_cnt, female_cnt,
       ROUND(avg_male, 0) AS avg_male_salary,
       ROUND(avg_female, 0) AS avg_female_salary,
       ROUND(100.0 * (avg_male - avg_female) / avg_male, 2) AS pay_gap_pct
FROM role_pay
WHERE male_cnt > 0 AND female_cnt > 0
ORDER BY pay_gap_pct DESC;

 #Q50 [Advanced] Compensation
 #Problem : What raise does each type of revision actually give?
 #Question: Using LAG(), compute the % salary increase of every revision in salary_history and summarise the average % by change reason.

WITH chg AS (
    SELECT employee_id, effective_date, annual_salary, change_reason,
           LAG(annual_salary) OVER (PARTITION BY employee_id ORDER BY effective_date) AS prev_salary
    FROM salary_history
)
SELECT change_reason,
       COUNT(*) AS revisions,
       ROUND(AVG(100.0 * (annual_salary - prev_salary) / prev_salary), 2) AS avg_increase_pct,
       ROUND(MIN(100.0 * (annual_salary - prev_salary) / prev_salary), 2) AS min_increase_pct,
       ROUND(MAX(100.0 * (annual_salary - prev_salary) / prev_salary), 2) AS max_increase_pct
FROM chg
WHERE prev_salary IS NOT NULL
GROUP BY change_reason
ORDER BY avg_increase_pct DESC;
#============================================================#

 #Q51 [Advanced] Data Quality
 #Problem : Before payroll sign-off, HR needs to be sure the employees table matches the salary history.
 #Question: Data-quality audit: reconcile employees.current_salary with each employee's latest salary_history record. How many match and how many don't?

WITH latest AS (
    SELECT employee_id, annual_salary,
           ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY effective_date DESC) AS rn
    FROM salary_history
)
SELECT COUNT(*) AS employees_checked,
       SUM(CASE WHEN e.current_salary =  l.annual_salary THEN 1 ELSE 0 END) AS matching,
       SUM(CASE WHEN e.current_salary <> l.annual_salary THEN 1 ELSE 0 END) AS mismatching
FROM employees e
JOIN latest l ON e.employee_id = l.employee_id AND l.rn = 1;
#============================================================#

 #Q52 [Advanced] Workforce Planning
 #Problem : The board asks for yearly hires, exits and the net change in headcount.
 #Question: Show hires, exits, net change and a running (cumulative) headcount for each year.

WITH hires AS (
    SELECT SUBSTR(hire_date, 1, 4) AS yr, COUNT(*) AS hires
    FROM employees GROUP BY SUBSTR(hire_date, 1, 4)
), exits AS (
    SELECT SUBSTR(exit_date, 1, 4) AS yr, COUNT(*) AS exits
    FROM employees WHERE exit_date IS NOT NULL GROUP BY SUBSTR(exit_date, 1, 4)
)
SELECT h.yr AS year,
       h.hires,
       COALESCE(x.exits, 0) AS exits,
       h.hires - COALESCE(x.exits, 0) AS net_change,
       SUM(h.hires - COALESCE(x.exits, 0)) OVER (ORDER BY h.yr) AS cumulative_headcount
FROM hires h
LEFT JOIN exits x ON h.yr = x.yr
ORDER BY h.yr;
#============================================================#

 #Q53 [Advanced] Workforce Planning
 #Problem : Headcount reports are needed 'as at' each year-end for audits.
 #Question: What was the headcount at each year-end (31-Dec) from 2021 to 2025 by department? (An employee counts if hired on/before that date and not yet exited.)

WITH year_ends AS (
    SELECT 2021 AS yr, '2021-12-31' AS ye UNION ALL
    SELECT 2022, '2022-12-31' UNION ALL
    SELECT 2023, '2023-12-31' UNION ALL
    SELECT 2024, '2024-12-31' UNION ALL
    SELECT 2025, '2025-12-31'
)
SELECT d.department_name,
       SUM(CASE WHEN y.yr = 2021 THEN 1 ELSE 0 END) AS hc_2021,
       SUM(CASE WHEN y.yr = 2022 THEN 1 ELSE 0 END) AS hc_2022,
       SUM(CASE WHEN y.yr = 2023 THEN 1 ELSE 0 END) AS hc_2023,
       SUM(CASE WHEN y.yr = 2024 THEN 1 ELSE 0 END) AS hc_2024,
       SUM(CASE WHEN y.yr = 2025 THEN 1 ELSE 0 END) AS hc_2025
FROM year_ends y
JOIN employees e ON e.hire_date <= y.ye AND (e.exit_date IS NULL OR e.exit_date > y.ye)
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY d.department_name;
#============================================================#

 #Q54 [Advanced] Attrition
 #Problem : Losing people in their first year is the most expensive kind of attrition.
 #Question: For each department, how many employees left within 12 months of joining, and what % of that department's exits is that?

WITH exits AS (
    SELECT department_id,
           CASE WHEN DATEDIFF(exit_date,hire_date) <= 365 THEN 1 ELSE 0 END AS early_exit
    FROM employees
    WHERE exit_date IS NOT NULL
)
SELECT d.department_name,
       COUNT(*) AS total_exits,
       SUM(early_exit) AS exits_within_12_months,
       ROUND(100.0 * SUM(early_exit) / COUNT(*), 1) AS early_exit_pct
FROM exits x
JOIN departments d ON x.department_id = d.department_id
GROUP BY d.department_name
ORDER BY early_exit_pct DESC;
#============================================================#

 #Q55 [Advanced] Attrition
 #Problem : Which managers are 'attrition hot-spots'?
 #Question: Among managers with at least 4 direct reports, which 10 have the highest team attrition rate?

WITH team AS (
    SELECT manager_id,
           COUNT(*) AS team_size,
           SUM(CASE WHEN employment_status <> 'Active' THEN 1 ELSE 0 END) AS leavers
    FROM employees
    GROUP BY manager_id
    HAVING COUNT(*) >= 4
)
SELECT m.employee_id AS manager_id, m.employee_name AS manager_name, d.department_name,
       t.team_size, t.leavers,
       ROUND(100.0 * t.leavers / t.team_size, 1) AS team_attrition_pct
FROM team t
JOIN employees m   ON t.manager_id = m.employee_id
JOIN departments d ON m.department_id = d.department_id
ORDER BY team_attrition_pct DESC, t.team_size DESC
LIMIT 10;
#============================================================#

 #Q56 [Advanced] Attrition
 #Problem : Attrition is a cost, not just a number; Finance wants an estimate.
 #Question: Assuming replacement cost = 50% of the leaver's annual salary, estimate the cost of attrition per department per exit year.

SELECT d.department_name,
       SUBSTR(e.exit_date, 1, 4) AS exit_year,
       COUNT(*) AS exits,
       SUM(e.current_salary) AS salary_of_leavers,
       ROUND(SUM(e.current_salary) * 0.5, 0) AS est_replacement_cost
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.exit_date IS NOT NULL
GROUP BY d.department_name, SUBSTR(e.exit_date, 1, 4)
ORDER BY d.department_name, exit_year;
#============================================================#

 #Q57 [Advanced] Attrition
 #Problem : Are we losing our best people or our weakest ones?
 #Question: Compare the average performance score and engagement of leavers vs. stayers in each department (use the analytics master table).

SELECT department_name,
       ROUND(AVG(CASE WHEN attrition_flag = 1 THEN avg_perf_score END), 2) AS perf_leavers,
       ROUND(AVG(CASE WHEN attrition_flag = 0 THEN avg_perf_score END), 2) AS perf_stayers,
       ROUND(AVG(CASE WHEN attrition_flag = 1 THEN avg_engagement END), 2) AS engagement_leavers,
       ROUND(AVG(CASE WHEN attrition_flag = 0 THEN avg_engagement END), 2) AS engagement_stayers
FROM employee_analytics_master
GROUP BY department_name
ORDER BY department_name;
#============================================================#

 #Q58 [Advanced] Attrition
 #Problem : HR wants a proactive early-warning list instead of only reacting to resignations.
 #Question: Build a flight-risk list: active employees with a high performance score (>= 4) but low engagement (< 3) who are paid below their role's midpoint, ranked by risk.

SELECT m.employee_id, m.employee_name, m.department_name, m.role_name,
       m.avg_perf_score, m.avg_engagement, m.absenteeism_rate,
       m.current_salary,
       ROUND(1.0 * m.current_salary / ((jr.salary_min + jr.salary_max) / 2.0), 2) AS compa_ratio
FROM employee_analytics_master m
JOIN job_roles jr ON m.role_name = jr.role_name
WHERE m.employment_status = 'Active'
  AND m.avg_perf_score >= 4
  AND m.avg_engagement < 3
  AND m.current_salary < (jr.salary_min + jr.salary_max) / 2.0
ORDER BY m.avg_engagement ASC, compa_ratio ASC, m.avg_perf_score DESC
LIMIT 25;
#============================================================#

 #Q59 [Advanced] Attrition
 #Problem : Does poor attendance predict resignation?
 #Question: Split employees into absenteeism quartiles (NTILE) and compare the attrition rate in each quartile.

WITH abs_rate AS (
    SELECT employee_id,
           100.0 * SUM(absentee_days) / SUM(working_days) AS absentee_pct
    FROM attendance_monthly
    GROUP BY employee_id
), quart AS (
    SELECT employee_id, absentee_pct,
           NTILE(4) OVER (ORDER BY absentee_pct) AS absenteeism_quartile
    FROM abs_rate
)
SELECT q.absenteeism_quartile,
       COUNT(*) AS employees,
       ROUND(MIN(q.absentee_pct), 2) AS min_absentee_pct,
       ROUND(MAX(q.absentee_pct), 2) AS max_absentee_pct,
       SUM(CASE WHEN e.employment_status <> 'Active' THEN 1 ELSE 0 END) AS leavers,
       ROUND(100.0 * SUM(CASE WHEN e.employment_status <> 'Active' THEN 1 ELSE 0 END) / COUNT(*), 1) AS attrition_pct
FROM quart q
JOIN employees e ON q.employee_id = e.employee_id
GROUP BY q.absenteeism_quartile
ORDER BY q.absenteeism_quartile;
#============================================================#

 #Q60 [Advanced] Attrition
 #Problem : Do richer benefits packages help retention?
 #Question: Group employees by the number of benefits they were ever enrolled in (3, 4, 5-6) and compare attrition rates.

WITH ben AS (
    SELECT employee_id, COUNT(*) AS benefits_enrolled
    FROM employee_benefits
    GROUP BY employee_id
)
SELECT CASE WHEN COALESCE(b.benefits_enrolled, 0) <= 3 THEN '1. 3 benefits'
            WHEN b.benefits_enrolled = 4 THEN '2. 4 benefits'
            ELSE '3. 5-6 benefits' END AS benefit_band,
       COUNT(*) AS employees,
       SUM(CASE WHEN e.employment_status <> 'Active' THEN 1 ELSE 0 END) AS leavers,
       ROUND(100.0 * SUM(CASE WHEN e.employment_status <> 'Active' THEN 1 ELSE 0 END) / COUNT(*), 1) AS attrition_pct
FROM employees e
LEFT JOIN ben b ON e.employee_id = b.employee_id
GROUP BY benefit_band
ORDER BY benefit_band;
#============================================================#

 #Q61 [Advanced] Engagement
 #Problem : What do people who leave feel differently about?
 #Question: For each survey category, compare the average score given by leavers vs. stayers and show the gap.

SELECT q.survey_category,
       ROUND(AVG(CASE WHEN e.employment_status =  'Active' THEN s.score END), 2) AS avg_score_stayers,
       ROUND(AVG(CASE WHEN e.employment_status <> 'Active' THEN s.score END), 2) AS avg_score_leavers,
       ROUND(AVG(CASE WHEN e.employment_status =  'Active' THEN s.score END)
           - AVG(CASE WHEN e.employment_status <> 'Active' THEN s.score END), 2) AS gap
FROM engagement_surveys s
JOIN survey_questions q ON s.question_id = q.question_id
JOIN employees e        ON s.employee_id = e.employee_id
GROUP BY q.survey_category
ORDER BY gap DESC;
#============================================================#

 #Q62 [Advanced] Recruitment
 #Problem : Recruiters need to quality-check hires, not just count them.
 #Question: Calculate 1-year retention by recruitment source (for employees hired on or before 2024-12-31, how many were still employed after 365 days?).

SELECT recruitment_source,
       COUNT(*) AS hires,
       SUM(CASE WHEN exit_date IS NULL OR DATEDIFF(exit_date, hire_date) > 365 THEN 1 ELSE 0 END) AS retained_1yr,
       ROUND(100.0 * SUM(CASE WHEN exit_date IS NULL OR DATEDIFF(exit_date, hire_date) > 365 THEN 1 ELSE 0 END) / COUNT(*), 1) AS retention_1yr_pct
FROM employees
WHERE hire_date <= '2024-12-31'
GROUP BY recruitment_source
ORDER BY retention_1yr_pct DESC;
#============================================================#

 #Q63 [Advanced] Recruitment
 #Problem : Where exactly does the hiring funnel leak, by department?
 #Question: Build a departmental recruitment funnel: applications, applications with at least one interview, offers made, offers accepted and hires.

WITH base AS (
    SELECT a.application_id, r.department_id, a.application_status,
           (SELECT COUNT(*) FROM interviews i WHERE i.application_id = a.application_id) AS interviews_cnt,
           o.offer_status
    FROM job_applications a
    JOIN job_requisitions r ON a.requisition_id = r.requisition_id
    LEFT JOIN job_offers o  ON a.application_id = o.application_id
)
SELECT d.department_name,
       COUNT(*) AS applications,
       SUM(CASE WHEN interviews_cnt > 0 THEN 1 ELSE 0 END) AS interviewed,
       SUM(CASE WHEN offer_status IS NOT NULL THEN 1 ELSE 0 END) AS offers_made,
       SUM(CASE WHEN offer_status = 'Accepted' THEN 1 ELSE 0 END) AS offers_accepted,
       SUM(CASE WHEN application_status = 'Hired' THEN 1 ELSE 0 END) AS hired,
       ROUND(100.0 * SUM(CASE WHEN application_status = 'Hired' THEN 1 ELSE 0 END) / COUNT(*), 2) AS overall_conversion_pct
FROM base b
JOIN departments d ON b.department_id = d.department_id
GROUP BY d.department_name
ORDER BY overall_conversion_pct DESC;
#============================================================#

 #Q64 [Advanced] Recruitment
 #Problem : Is the interview process too harsh in later rounds?
 #Question: For each interview round, show how many interviews were held, the pass rate, and the drop-off in volume vs. the previous round (LAG).

WITH rounds AS (
    SELECT round_number,
           COUNT(*) AS interviews,
           SUM(CASE WHEN interview_result IN ('Passed','Selected') THEN 1 ELSE 0 END) AS passed
    FROM interviews
    GROUP BY round_number
)
SELECT round_number, interviews, passed,
       ROUND(100.0 * passed / interviews, 1) AS pass_rate_pct,
       LAG(interviews) OVER (ORDER BY round_number) AS prev_round_interviews,
       ROUND(100.0 * (LAG(interviews) OVER (ORDER BY round_number) - interviews)
             / LAG(interviews) OVER (ORDER BY round_number), 1) AS volume_dropoff_pct
FROM rounds
ORDER BY round_number;
#============================================================#

 #Q65 [Advanced] Talent Mobility
 #Problem : Employees who wait too long for promotion tend to leave.
 #Question: What is the average number of days from hire date to first promotion in each department?

WITH first_promo AS (
    SELECT employee_id, MIN(promotion_date) AS first_promotion_date
    FROM promotions
    GROUP BY employee_id
)
SELECT d.department_name,
       COUNT(*) AS promoted_employees,
       ROUND(AVG(DATEDIFF(fp.first_promotion_date, e.hire_date)), 0) AS avg_days_to_first_promotion,
       ROUND(AVG(DATEDIFF(fp.first_promotion_date, e.hire_date)) / 365.0, 2) AS avg_years
FROM first_promo fp
JOIN employees e   ON fp.employee_id = e.employee_id
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY avg_days_to_first_promotion;
#============================================================#

 #Q66 [Advanced] Talent Mobility
 #Problem : Do promotions actually help retain people?
 #Question: Compare the attrition rate and average salary of employees who have been promoted vs. those who haven't.

WITH promoted AS (
    SELECT DISTINCT employee_id FROM promotions
)
SELECT CASE WHEN p.employee_id IS NULL THEN 'Never promoted' ELSE 'Promoted' END AS promotion_status,
       COUNT(*) AS employees,
       SUM(CASE WHEN e.employment_status <> 'Active' THEN 1 ELSE 0 END) AS leavers,
       ROUND(100.0 * SUM(CASE WHEN e.employment_status <> 'Active' THEN 1 ELSE 0 END) / COUNT(*), 1) AS attrition_pct,
       ROUND(AVG(e.current_salary), 0) AS avg_salary
FROM employees e
LEFT JOIN promoted p ON e.employee_id = p.employee_id
GROUP BY promotion_status;
#============================================================#

 #Q67 [Advanced] Learning & Development
 #Problem : The L&D head must justify next year's budget: does training move the needle on performance?
 #Question: Bucket employees by number of completed trainings (0, 1-2, 3+) and compare their average performance score.

WITH tr AS (
    SELECT employee_id, COUNT(*) AS completed_trainings
    FROM employee_training
    WHERE completion_status = 'Completed'
    GROUP BY employee_id
), perf AS (
    SELECT employee_id, AVG(performance_score) AS avg_score
    FROM performance_reviews
    GROUP BY employee_id
)
SELECT CASE WHEN COALESCE(tr.completed_trainings, 0) = 0 THEN '0 trainings'
            WHEN tr.completed_trainings <= 2 THEN '1-2 trainings'
            ELSE '3+ trainings' END AS training_band,
       COUNT(*) AS employees,
       ROUND(AVG(p.avg_score), 3) AS avg_performance_score
FROM employees e
JOIN perf p ON e.employee_id = p.employee_id
LEFT JOIN tr ON e.employee_id = tr.employee_id
GROUP BY training_band
ORDER BY training_band;
#============================================================#

 #Q68 [Advanced] Compensation
 #Problem : High performers who sit at the bottom of their pay grade are a flight and fairness risk.
 #Question: Using PERCENT_RANK within each salary grade, list active employees in the bottom 20% of their grade's pay who have an average performance score of at least 4.

WITH pr AS (
    SELECT e.employee_id, e.employee_name, e.grade_id, e.current_salary,
           PERCENT_RANK() OVER (PARTITION BY e.grade_id ORDER BY e.current_salary) AS pay_percentile
    FROM employees e
    WHERE e.employment_status = 'Active'
)
SELECT sg.grade_code, pr.employee_id, pr.employee_name, m.department_name, m.role_name,
       pr.current_salary, ROUND(100 * pr.pay_percentile, 1) AS pay_percentile_in_grade,
       m.avg_perf_score
FROM pr
JOIN salary_grades sg ON pr.grade_id = sg.grade_id
JOIN employee_analytics_master m ON pr.employee_id = m.employee_id
WHERE pr.pay_percentile <= 0.20
  AND m.avg_perf_score >= 4
ORDER BY sg.grade_code, pay_percentile_in_grade, m.avg_perf_score DESC
LIMIT 25;
#============================================================#

 #Q69 [Advanced] Executive Reporting
 #Problem : The CHRO wants ONE dashboard-ready table summarising each department's people health.
 #Question: Build a department scorecard: headcount, active, attrition %, avg salary, avg performance, avg engagement, avg absenteeism %, promotions per 100 employees, plus an overall 'risk rank' (highest attrition = 1).

SELECT department_name,
       COUNT(*) AS headcount,
       SUM(CASE WHEN attrition_flag = 0 THEN 1 ELSE 0 END) AS active_employees,
       ROUND(100.0 * SUM(attrition_flag) / COUNT(*), 1) AS attrition_pct,
       ROUND(AVG(current_salary), 0) AS avg_salary,
       ROUND(AVG(avg_perf_score), 2) AS avg_performance,
       ROUND(AVG(avg_engagement), 2) AS avg_engagement,
       ROUND(100.0 * AVG(absenteeism_rate), 2) AS avg_absenteeism_pct,
       ROUND(100.0 * SUM(promotions_count) / COUNT(*), 1) AS promotions_per_100_emp,
       RANK() OVER (ORDER BY 1.0 * SUM(attrition_flag) / COUNT(*) DESC) AS attrition_risk_rank
FROM employee_analytics_master
GROUP BY department_name
ORDER BY attrition_risk_rank;
