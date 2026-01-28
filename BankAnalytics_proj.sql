use practice;

##Year wise loan amount stats
##Grade and sub grade wise revolving balance
##Total payment for verified status Vs Total payment for non verified status
##state wise and last credit pull date wise status
##Home ownership Vs last payment date stats


##Year wise loan amount stats
select year, concat(round(t_amnt/1000000,2)," m")as Total_loan_amnt,
concat(round(((t_amnt-py)/py)*100,0),"%") as YOY_change from(
select year(issue_d) as year, sum(loan_amnt) as t_amnt,
lag(sum(loan_amnt)) over(order by year(issue_d)) as py
from finance_1
group by 1) as ab;

##Grade & sub grade wise revolving balance

select grade, sub_grade, sum(revol_bal) as Revolving_bal from finance_1 as a inner join finance_2 as b
on a.id=b.id
group by 1,2
order by 3;

##Total payment for verified status and totol payment for non verified status

select verification_status, concat(round(sum(total_pymnt)/1000000,2)," m") as Total_payment from finance_1 as a inner join finance_2 as b
on a.id=b.id
where verification_status<> "source verified"
group by 1;

#state wise & last credit pull date wise status


select addr_state, year(last_credit_pull_d) as last_credit_pull_year, loan_status, count(*) as count from finance_1 as a 
inner join finance_2 as b
on a.id=b.id
group by 1,2,3
order by 1,2;

##Home ownership vs last payment date stats


select home_ownership, last_pymnt_year, month, Total_rec_prncp, Total_rec_pymnt from (
select a.home_ownership, year(b.last_pymnt_d) last_pymnt_year, month(b.last_pymnt_d) lastmonth, 
monthname(b.last_pymnt_d) as month,
concat(round(sum(b.total_rec_prncp)/1000,2)," k") as Total_rec_prncp, 
concat(round(sum(b.total_pymnt)/1000,2)," k") Total_rec_pymnt from finance_1 as a 
inner join finance_2 as b
on a.id=b.id
group by 1,2,3,4
order by 1,2,3) ab;


