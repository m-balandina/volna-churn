--Доля закончившихся подписок по каждому тарифу.
-- по сравнению с общим кол-вом подписок по тарифу.

select p.plan_name, COUNT(s.subscription_id) as all_quan_plan,
sum(case when s.ended_on is not null then 1 else 0 end) as ended_sub,
round((sum(case when s.ended_on is not null then 1 else 0 end)*100.0/
COUNT(s.subscription_id)),2) as percentage_ended
from subscriptions s
	inner join plans p 
	on p.plan_id = s.plan_id
group by p.plan_name
order by percentage_ended desc
