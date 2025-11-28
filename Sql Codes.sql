use project_egy_labor_sql;
SET SQL_SAFE_UPDATES = 0;
SET GLOBAL max_allowed_packet = 6710886400000; -- 64MB
SET GLOBAL net_read_timeout = 6000000;
SET GLOBAL net_write_timeout = 6000000;
SET GLOBAL wait_timeout = 6000000;
SET GLOBAL interactive_timeout = 6000000;

-- SELECT * FROM project_egy_labor_sql.raw_data;
describe raw_data;
-- ALTER TABLE project_egy_labor_sql.raw_data CHANGE COLUMN `ï»؟ind_key` `ind_key` INT PRIMARY KEY AUTO_INCREMENT ;

############### 1- Create DIM Tables
#######################################################################################################################################################################################
###1-1 Region
#######################################################################################################################################################################################
/*
CREATE TABLE IF NOT EXISTS `dim_region` (
	region_key int primary key auto_increment
	,gov varchar(25) unique
	,region	varchar(25)
    ,region_group varchar(15)
) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_general_ci;
*/
-- SHOW INDEXES FROM dim_region;
-- ALTER TABLE dim_region DROP INDEX gov;
/*
insert into dim_region (gov	,region)
	select gov,region from raw_data;
*/
#### Remove dublicates
/*
DELETE t1
FROM dim_region t1
JOIN dim_region t2 
ON t1.gov = t2.gov 
AND t1.region_key > t2.region_key;
*/
### Fill region group
-- UPDATE dim_region SET gov = "Alex" where gov = "Alex.";
/*
UPDATE dim_region SET
	region_group = "Gr. Cairo"
WHERE gov IN ("Cairo","Giza","Kalyoubia");
*/
/*
UPDATE dim_region SET
	region_group = "Coast"
WHERE gov IN ("Alex","Suez","Port-Said","Ismailia");
*/
/*
UPDATE dim_region SET
	region_group = "Upper"
WHERE gov IN ("Aswan","Asyout","Beni-Suef","Fayoum","Luxur","Menia","Qena","Suhag");
*/
-- select gov from dim_region where region_group is null;
/*
UPDATE dim_region SET
	region_group = "Delta"
WHERE region_group is null;
*/
-- select * from dim_region;
#######################################################################################################################################################################################
###1-2 Education
#######################################################################################################################################################################################
/*
CREATE TABLE IF NOT EXISTS `dim_edu` (
	edu_key int primary key auto_increment
	,educational_attainment varchar(70) 
	,years_of_school int(2)
) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_general_ci;
*/
/*
insert into dim_edu (educational_attainment,years_of_school)
	(select educational_attainment,years_of_school from raw_data)
*/
/*
DELETE t1
FROM dim_edu t1
JOIN dim_edu t2
ON t1.educational_attainment = t2.educational_attainment
AND t1.years_of_school = t2.years_of_school
AND t1.edu_key > t2.edu_key;
*/
-- select * from dim_edu;
#######################################################################################################################################################################################
###1-3 Occupation
#######################################################################################################################################################################################
/*
CREATE TABLE IF NOT EXISTS `dim_occupation` (
	occupation_key int primary key auto_increment
	,occupation_one_digit varchar(100) 
	,occupation_two_digit varchar(100)
) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_general_ci;
*/
/*
insert into dim_occupation (occupation_one_digit,occupation_two_digit)
	(select occupation_one_digit,occupation_two_digit from raw_data)
*/    
-- select * from dim_occupation;
/*
DELETE t1
FROM dim_occupation t1
JOIN dim_occupation t2
ON t1.occupation_one_digit = t2.occupation_one_digit
AND t1.occupation_two_digit = t2.occupation_two_digit
AND t1.occupation_key > t2.occupation_key;
*/
#######################################################################################################################################################################################
###1-4 Job Requirements
#######################################################################################################################################################################################
/*
select 
	job_skills_training_prog
	,is_course_online
    ,an_internship
    ,an_apprenticeship
    ,non_formal_education_course
    ,training_provided_by_employer
    ,job_require_technical_skills
    ,participate_training_other_regular_edu
    ,min_education_req_job
from raw_data;
select
	length(min_education_req_job) as len
from raw_data order by len desc;
*/
/*
CREATE TABLE IF NOT EXISTS `dim_job_requirements` (
	req_key int primary key auto_increment
	,job_skills_training_prog varchar(3) 
	,is_course_online varchar(3)
    ,an_internship varchar(3)
    ,an_apprenticeship varchar(3)
    ,non_formal_education_course varchar(3)
    ,training_provided_by_employer varchar(3)
    ,job_require_technical_skills varchar(3)
    ,participate_training_other_regular_edu varchar(3)
    ,min_education_req_job varchar(20)
) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_general_ci;
*/
/*
insert into dim_job_requirements (
	job_skills_training_prog
	,is_course_online
    ,an_internship
    ,an_apprenticeship
    ,non_formal_education_course
    ,training_provided_by_employer
    ,job_require_technical_skills
    ,participate_training_other_regular_edu
    ,min_education_req_job
)
(
	select 
		job_skills_training_prog
		,is_course_online
		,an_internship
		,an_apprenticeship
		,non_formal_education_course
		,training_provided_by_employer
		,job_require_technical_skills
		,participate_training_other_regular_edu
		,min_education_req_job
	from raw_data
);
*/
/*
DELETE t1
FROM dim_job_requirements t1
JOIN dim_job_requirements t2
ON t1.job_skills_training_prog = t2.job_skills_training_prog
AND t1.is_course_online = t2.is_course_online
AND t1.an_internship = t2.an_internship
AND t1.non_formal_education_course = t2.non_formal_education_course
AND t1.training_provided_by_employer = t2.training_provided_by_employer
AND t1.job_require_technical_skills = t2.job_require_technical_skills
AND t1.participate_training_other_regular_edu = t2.participate_training_other_regular_edu
AND t1.min_education_req_job = t2.min_education_req_job
AND t1.req_key > t2.req_key;
*/
-- select * from dim_job_requirements;
#######################################################################################################################################################################################
###1-5 Individual
#######################################################################################################################################################################################
/*
select 
	individual_weight
	,is_course_online
    ,an_internship
    ,an_apprenticeship
    ,non_formal_education_course
    ,training_provided_by_employer
    ,job_require_technical_skills
    ,participate_training_other_regular_edu
    ,min_education_req_job
from raw_data;
select
	length(min_education_req_job) as len
from raw_data order by len desc;
*/
### *** re-fill missing column GENDER *** ###
/*
select * from gender group by gender;
alter table raw_data
	add column gender varchar(6);
ALTER TABLE gender CHANGE COLUMN `ï»¿IND_KEY` `ind_key` INT;
delete from gender where ind_key = 0 limit 1;
update raw_data set gender = "Female"
where ind_key in (select ind_key from gender where gender = "Female");
update raw_data set gender = "Male"
where ind_key in (select ind_key from gender where gender = "Male");
select count(gender) from raw_data where gender = "Female";
select count(gender) from gender where gender = "Female";
*/
/*
select
   individual_weight
   ,gender
   ,brthyr
   ,age
   ,agegrp
   ,marital
   ,quintiles_household_wealth
   ,monthly_wage
   ,no_of_hours_day
   ,laptop
   ,tablet
   ,mobile_phone
   ,digital_payment
   ,used_internet_computer_tablet
   ,first_purpose_use_internet
   ,have_bank_accounts
from raw_data;
CREATE TABLE IF NOT EXISTS `dim_individual` (
	ind_key int primary key auto_increment
    ,emp_key int
	,individual_weight decimal(10,6)
	,gender varchar(6)
    ,brthyr year
    ,age int(3)
    ,agegrp varchar(5)
    ,marital varchar(21)
    ,quintiles_household_wealth tinyint
    ,monthly_wage decimal(10,2)
    ,no_of_hours_day int(2)
    ,laptop varchar(3)
    ,tablet varchar(3)
    ,mobile_phone varchar(3)
    ,digital_payment varchar(3)
    ,used_internet_computer_tablet varchar(3)
    ,first_purpose_use_internet varchar(20)
    ,have_bank_accounts varchar(3)
) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_general_ci;
select
	length(first_purpose_use_internet) as len
from raw_data order by len desc;
*/
/*
insert into dim_individual (
	individual_weight
	,gender
    ,brthyr
    ,age
    ,agegrp
    ,marital
    ,quintiles_household_wealth
    ,monthly_wage
    ,no_of_hours_day
    ,laptop
    ,tablet
    ,mobile_phone
    ,digital_payment
    ,used_internet_computer_tablet
    ,first_purpose_use_internet
    ,have_bank_accounts
)
(
	select
		individual_weight
		,gender
		,brthyr
		,age
		,agegrp
		,marital
		,quintiles_household_wealth
		,monthly_wage
		,no_of_hours_day
		,laptop
		,tablet
		,mobile_phone
		,digital_payment
		,used_internet_computer_tablet
		,first_purpose_use_internet
		,have_bank_accounts
	from raw_data
);
*/
/*
DELETE t1
FROM dim_individual t1
JOIN dim_individual t2
ON t1.individual_weight = t2.individual_weight
AND t1.gender = t2.gender
AND t1.brthyr = t2.brthyr
AND t1.age = t2.age
AND t1.agegrp = t2.agegrp
AND t1.marital = t2.marital
AND t1.quintiles_household_wealth = t2.quintiles_household_wealth
AND t1.monthly_wage = t2.monthly_wage
AND t1.no_of_hours_day = t2.no_of_hours_day
AND t1.laptop = t2.laptop
AND t1.tablet = t2.tablet
AND t1.mobile_phone = t2.mobile_phone
AND t1.digital_payment = t2.digital_payment
AND t1.used_internet_computer_tablet = t2.used_internet_computer_tablet
AND t1.first_purpose_use_internet = t2.first_purpose_use_internet
AND t1.have_bank_accounts = t2.have_bank_accounts
AND t1.ind_key > t2.ind_key;
*/
-- select count(*) from dim_individual;

############### 2- Create The Fact Table
#######################################################################################################################################################################################
#### 2-1 Employee
#######################################################################################################################################################################################
-- CREATE TABLE IF NOT EXISTS `employee` AS SELECT * FROM raw_data;
-- describe employee;
/*
ALTER TABLE employee 
    CHANGE COLUMN no_of_hours_day no_of_hours_day INT(2);
ALTER TABLE employee 
    CHANGE COLUMN monthly_wage monthly_wage DECIMAL(10,2);
ALTER TABLE employee 
    CHANGE COLUMN quintiles_household_wealth quintiles_household_wealth INT(1);
ALTER TABLE employee 
    CHANGE COLUMN brthyr brthyr YEAR;
ALTER TABLE employee 
    CHANGE COLUMN individual_weight individual_weight DECIMAL(10,6);
*/
-- select individual_weight,individual_key from employee;
#######################################################################################################################################################################################
#### 2-2 Foriegn Columns
#######################################################################################################################################################################################
/*
alter table employee
    change column ind_key ind_key int primary key
    ,add column individual_key int not null after ind_key
    ,add column region_key int not null after individual_key
    ,add column edu_key int not null after region_key
    ,add column occupation_key int not null after edu_key
    ,add column req_key int not null after occupation_key;
*/
### Fill data to new columns & drop dims columns from the fact table
/*
UPDATE employee e
JOIN dim_edu d 
    ON e.educational_attainment = d.educational_attainment
    AND e.years_of_school = d.years_of_school
SET e.edu_key = d.edu_key;

alter table employee
    drop educational_attainment
    ,drop years_of_school;

select count(ind_key) from employee where edu_key = 0;
select * from employee where edu_key = 0;

UPDATE employee e
JOIN dim_job_requirements d 
    ON e.job_skills_training_prog = d.job_skills_training_prog
    AND e.is_course_online = d.is_course_online
    AND e.an_internship = d.an_internship
    AND e.an_apprenticeship = d.an_apprenticeship
    AND e.non_formal_education_course = d.non_formal_education_course
    AND e.training_provided_by_employer = d.training_provided_by_employer
    AND e.job_require_technical_skills = d.job_require_technical_skills
    AND e.participate_training_other_regular_edu = d.participate_training_other_regular_edu
    AND e.min_education_req_job = d.min_education_req_job
    AND e.req_key = 0
SET e.req_key = d.req_key;


select count(ind_key) from employee where req_key = 0;

alter table employee
  drop job_skills_training_prog
  ,drop is_course_online
  ,drop an_internship
  ,drop an_apprenticeship
  ,drop non_formal_education_course
  ,drop training_provided_by_employer
  ,drop job_require_technical_skills
  ,drop participate_training_other_regular_edu
  ,drop min_education_req_job;

UPDATE employee e
JOIN dim_occupation d 
    ON e.occupation_one_digit = d.occupation_one_digit
    AND e.occupation_two_digit = d.occupation_two_digit
    AND e.occupation_key = 0
SET e.occupation_key = d.occupation_key;

alter table employee
    drop occupation_one_digit
    ,drop occupation_two_digit;

UPDATE employee e
JOIN dim_region d 
    ON e.gov = d.gov
    AND e.region_key = 0
SET e.region_key = d.region_key;

alter table employee
    drop gov
    ,drop region
;
select * from employee where region_key = 0;

UPDATE employee e
JOIN dim_individual d 
    ON e.individual_weight = d.individual_weight
    AND e.gender = d.gender
    AND e.brthyr = d.brthyr
    AND e.age = d.age
    AND e.agegrp = d.agegrp
    AND e.marital = d.marital
    AND e.quintiles_household_wealth = d.quintiles_household_wealth
    AND e.monthly_wage = d.monthly_wage
    AND e.no_of_hours_day = d.no_of_hours_day
    AND e.laptop = d.laptop
    AND e.tablet = d.tablet
    AND e.mobile_phone = d.mobile_phone
    AND e.digital_payment = d.digital_payment
    AND e.used_internet_computer_tablet = d.used_internet_computer_tablet
    AND e.first_purpose_use_internet = d.first_purpose_use_internet
    AND e.have_bank_accounts = d.have_bank_accounts
    AND e.individual_key = 0
SET e.individual_key = d.ind_key;

alter table employee
	drop individual_weight
    ,drop gender
    ,drop brthyr
    ,drop age
    ,drop agegrp
    ,drop marital
    ,drop quintiles_household_wealth
    ,drop laptop
    ,drop tablet
    ,drop mobile_phone
    ,drop digital_payment
    ,drop used_internet_computer_tablet
    ,drop first_purpose_use_internet
    ,drop have_bank_accounts;
*/
#######################################################################################################################################################################################
#### 2-3 Create Enhanced Entity Relationship (EER)
#######################################################################################################################################################################################
/*
alter table employee
	add constraint eer_individual foreign key (individual_key) references dim_individual(ind_key) on update cascade on delete cascade
	,add constraint eer_region foreign key (region_key) references dim_region(region_key) on update cascade on delete cascade
    ,add constraint eer_edu foreign key (edu_key) references dim_edu(edu_key) on update cascade on delete cascade
	,add constraint eer_occ foreign key (occupation_key) references dim_occupation(occupation_key) on update cascade on delete cascade
	,add constraint eer_req foreign key (req_key) references dim_job_requirements(req_key) on update cascade on delete cascade
;
*/
-- describe employee;

############################################################################################################################################################################
###################################################################        ANALYSIS      ###################################################################################
############################################################################################################################################################################

# 1- AVG WAGE ACCORDING TO REGION
select
  rg.region_group as Region
  ,round(avg(e.monthly_wage),2) as `AVG Wage`
from employee e
inner join dim_region rg on e.region_key = rg.region_key
inner join dim_individual ind on e.ind_key = ind.ind_key
group by rg.region_group
order by `AVG Wage` desc;
########################################
# 2- AVG WAGE ACCORDING TO EDUCATION
select
  ed.educational_attainment as Education
  ,round(avg(e.monthly_wage),2) as `AVG Wage`
from employee e
inner join dim_edu ed on e.edu_key = ed.edu_key
inner join dim_individual ind on e.ind_key = ind.ind_key
group by ed.educational_attainment
order by `AVG Wage` desc;
########################################
# 3- AVG WAGE ACCORDING TO OCCUPATION
select
  occ.occupation_one_digit as `Occupation Category`
  ,round(avg(e.monthly_wage),2) as `AVG Wage`
from employee e
inner join dim_occupation occ on e.occupation_key = occ.occupation_key
inner join dim_individual ind on e.ind_key = ind.ind_key
group by occ.occupation_one_digit
order by `AVG Wage` desc;
# 4- AVG WAGE ACCORDING TO OCCUPATION Detailed
select
  occ.occupation_one_digit as `Occupation Category`
  ,occ.occupation_two_digit as `Occupation Sub Category`
  ,round(avg(e.monthly_wage),2) as `AVG Wage`
from employee e
inner join dim_occupation occ on e.occupation_key = occ.occupation_key
inner join dim_individual ind on e.ind_key = ind.ind_key
group by occ.occupation_one_digit,occ.occupation_two_digit
order by `AVG Wage` desc;
# 5- AVG WAGE ACCORDING TO OCCUPATION & Gender
select
  occ.occupation_one_digit as `Occupation Category`
  ,ind.gender as gender
  ,round(avg(e.monthly_wage),2) as `AVG Wage`
from employee e
inner join dim_occupation occ on e.occupation_key = occ.occupation_key
inner join dim_individual ind on e.ind_key = ind.ind_key
group by occ.occupation_one_digit,ind.gender
order by `Occupation Category`,`AVG Wage` desc;
# 6- AVG WORKING HOURS ACCORDING TO OCCUPATION
select
  occ.occupation_one_digit as `Occupation Category`
  ,round(avg(e.`no_of_hours_day`),0) as `AVG W.H.`
from employee e
inner join dim_occupation occ on e.occupation_key = occ.occupation_key
inner join dim_individual ind on e.ind_key = ind.ind_key
group by occ.occupation_one_digit
order by `Occupation Category` desc;
# 7- GENDER RATIO PER OCCUPATION ACCORDING TO INDIVIDUAL
SELECT
    occ.occupation_one_digit AS `Occupation Category`,
    CONCAT(ROUND(
        SUM(CASE WHEN ind.gender = 'Male' THEN 1 ELSE 0 END) /
        (IFNULL(SUM(CASE WHEN ind.gender = 'Female' THEN 1 ELSE 0 END), 0) + NULLIF(SUM(CASE WHEN ind.gender = 'Male' THEN 1 ELSE 0 END), 0)
        ),
        2
    ) * 100 ,'%') AS Male_Ratio,
    CONCAT(ROUND(
        SUM(CASE WHEN ind.gender = 'Female' THEN 1 ELSE 0 END) /
        (IFNULL(SUM(CASE WHEN ind.gender = 'Female' THEN 1 ELSE 0 END), 0) + NULLIF(SUM(CASE WHEN ind.gender = 'Male' THEN 1 ELSE 0 END), 0)
        ),
        2
    ) * 100,'%') AS Female_Ratio
FROM employee e
INNER JOIN dim_occupation occ ON e.occupation_key = occ.occupation_key
INNER JOIN dim_individual ind ON e.ind_key = ind.ind_key
GROUP BY occ.occupation_one_digit
ORDER BY `Occupation Category`;

SELECT * FROM employee limit 5;
# 8- NO OF SATISFIED EMPLOYEES - CURRENT JOB
SELECT 
	satisfied_current_job
    ,COUNT(ind_key) as count
    ,CONCAT(ROUND(COUNT(ind_key) / (SELECT COUNT(ind_key) FROM employee) * 100,2),"%") as percentage
from employee
group by satisfied_current_job
order by count desc;
# 9- NO OF SATISFIED EMPLOYEES PER OCCUBATION
SELECT
    occ.occupation_one_digit AS `Occupation Category`
    ,e.satisfied_current_job AS `satisfaction`
    ,COUNT(*) AS `# employees`
    ,CONCAT(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employee),2), '%') AS `percentage all`
    ,CONCAT(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY occ.occupation_one_digit),2), '%') AS `percentage by category`
FROM employee e
INNER JOIN dim_occupation occ ON e.occupation_key = occ.occupation_key
GROUP BY occ.occupation_one_digit,e.satisfied_current_job
ORDER BY `Occupation Category` DESC;
# 10- NO OF SATISFIED EMPLOYEES ACCORDING TO WAGES AND OCCUPATION
SELECT
    occ.occupation_one_digit AS `Occupation Category`
    ,e.earnings_wages AS `Earnings/Wages Level`
    ,COUNT(*) AS `# employees`
    ,CONCAT(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employee),2), '%') AS `percentage all`
    ,CONCAT(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY occ.occupation_one_digit),2), '%') AS `percentage by category`
FROM employee e
INNER JOIN dim_occupation occ ON e.occupation_key = occ.occupation_key
GROUP BY occ.occupation_one_digit,e.earnings_wages
ORDER BY `Occupation Category` DESC,`Earnings/Wages Level`;
# 11- Job stability according to occupations
SELECT
    occ.occupation_one_digit AS `Occupation Category`
    ,e.job_stability AS `job stability`
    ,COUNT(*) AS `# employees`
    ,CONCAT(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employee),2), '%') AS `percentage all`
    ,CONCAT(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY occ.occupation_one_digit),2), '%') AS `percentage by category`
FROM employee e
INNER JOIN dim_occupation occ ON e.occupation_key = occ.occupation_key
GROUP BY occ.occupation_one_digit,e.job_stability
ORDER BY `Occupation Category` DESC,`job stability`;
# 12- Job stability according to educational attainment
SELECT
    ed.educational_attainment AS `EDUCATION`
    ,e.job_stability AS `stability`
    ,COUNT(*) AS `# employees`
    ,CONCAT(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employee),2), '%') AS `percentage all`
    ,CONCAT(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY ed.educational_attainment),2), '%') AS `percentage by education`
FROM employee e
INNER JOIN dim_edu ed ON e.edu_key = ed.edu_key
GROUP BY ed.educational_attainment,e.job_stability
ORDER BY `EDUCATION` DESC,`stability`;
# 13- Job stability according to regions
SELECT
    rgn.region_group AS `Region`,
    e.job_stability AS `stability`,
    COUNT(*) AS `# employees`,
    CONCAT(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employee),2), '%') AS `percentage all`,
    CONCAT(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY rgn.region_group),2), '%') AS `percentage by region`
FROM employee e
INNER JOIN dim_region rgn ON e.region_key = rgn.region_key
GROUP BY rgn.region_group,e.job_stability
ORDER BY `Region` DESC,`stability`;