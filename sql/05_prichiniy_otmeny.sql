with gone_subs as(
select sum(case when s.plan_id <> 4 then 1 else 0 end) as others_gone,
sum(case when s.plan_id = 4 then 1 else 0 end) as family_gone from subscriptions s
where s.ended_on is not null)
select s1.cancel_reason, 'Другие тарифы' as plans,
round((sum(case when s1.plan_id <> 4 then 1 else 0 end) * 100.0/ others_gone),2) 
as precentage_plans
from subscriptions s1
inner join plans p
on p.plan_id = s1.plan_id
cross join gone_subs
where s1.ended_on is not null
group by s1.cancel_reason
union
select s1.cancel_reason, 'Семейный',
round((sum(case when s1.plan_id = 4 then 1 else 0 end) * 100.0 / family_gone),2)
as precentage_plans
from subscriptions s1
inner join plans p
on p.plan_id = s1.plan_id
cross join gone_subs
where s1.ended_on is not null
group by s1.cancel_reason
