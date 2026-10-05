HR ANALYTICS SQL PROJECT
69 SQL queries solving real HR business problems | MySQL | 24 tables | 1,200 employees

WHAT THIS IS
An HR database of 1,200 employees. I answered the questions that the CHRO,
Finance, Hiring and L&D teams would ask, from basic reports to advanced analysis.

BUSINESS PROBLEMS SOLVED

EASY (20 queries): "What does our workforce look like?"
- How many employees do we have, and how many left?
- Headcount, gender mix and salary spread by department and city
- Which hiring sources, exit reasons and benefits matter most?

INTERMEDIATE (25 queries): "Where is the problem?"
- Which departments and cities have the highest attrition?
- Why do people leave, and how do leavers rate their managers?
- Is there a gender pay gap? Who is paid near the bottom of their band?
- Which recruitment source converts best? How long do vacancies stay open?
- Do departments differ in absenteeism and work-from-home use?

ADVANCED (24 queries): "What should we do about it?"
- Who is likely to leave next? (flight-risk list)
- Who is under-paid for their role? (compa-ratio)
- How many people quit in their first year, and what does attrition cost?
- Where does the hiring funnel leak? Which source gives staff who stay?
- Do promotions or training improve retention and performance?
- One department scorecard with a risk rank for leadership

KEY FINDINGS
- Attrition is 22.5%; Finance is highest at 24.7%
- 46% of leavers quit within their first year
- Top exit reason: better career opportunity (34%)
- LinkedIn hires stay longest (96.7% retained after 1 year)
- Promoted employees leave less (18.3% vs 23.0%)
- 24 high performers are disengaged and under-paid (flight risk)

HOW TO RUN
1. Run sql/01_create_and_load_database.sql  (creates the database and loads the data)
2. USE hr_analytics;
3. Run queries from sql/02_hr_analytics_queries_mysql.sql, one at a time

SKILLS
SQL (joins, CTEs, window functions) | HR analytics | Power BI | Tableau

Author: Your Name | your LinkedIn or email
