select p.plan_name, p.price_month, u.signup_channel, COUNT(s.subscription_id) as all_quan_plan,
sum(case when s.ended_on is not null then 1 else 0 end) as ended_sub,
round((sum(case when s.ended_on is not null then 1 else 0 end)*100.0/
COUNT(s.subscription_id)),2) as percentage_ended,
round(avg(JULIANDAY(s.ended_on) - JULIANDAY(s.started_on)),2) as avg_days_gone
from subscriptions s
	inner join plans p 
	on p.plan_id = s.plan_id
	inner join users u 
	on u.user_id = s.user_id
group by s.plan_id, u.signup_channel, p.plan_name, p.price_month
order by p.plan_name desc
