-- Из 190 активных подписок канала - 61 (32%) почти не смотрят, из них 52 не заходили ни разу. 
-- Деньги по ним идут.

with less_120 as (
select u.signup_channel,
count(s.subscription_id) as subs_less_120 from subscriptions s
	inner join users u 
	on u.user_id = s.user_id 
where s.ended_on is null
and u.user_id in (select ws.user_id from watch_sessions ws 
group by ws.user_id
having sum(ws.minutes) < 120)
group by u.signup_channel)
select u2.signup_channel, count(s2.subscription_id) as подписок_всего, 
less_120.subs_less_120 as мало_смотрят,
sum(case when not exists (select 1 from watch_sessions ws where ws.user_id = u2.user_id)
then 1 else 0 end ) as ни_разу_не_заходили,
round(((less_120.subs_less_120 + sum(case when not exists 
(select 1 from watch_sessions ws where ws.user_id = u2.user_id) then 1 else 0 end)) * 100.0 / count(s2.subscription_id)),1)
 as доля_молчащих
from subscriptions s2
	inner join users u2
	on u2.user_id = s2.user_id
	inner join less_120
	on less_120.signup_channel = u2.signup_channel
where s2.ended_on is null
group by u2.signup_channel
