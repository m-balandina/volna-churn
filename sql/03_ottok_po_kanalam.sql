select u.signup_channel, count(s.subscription_id) as subs,
sum(case when s.ended_on is not null then 1 else 0 END) as subs_gone,
round((sum(case when s.ended_on is not null then 1 else 0 END)*100.0 /
count(s.subscription_id)),2) as perc_gone,
(select round(avg(um.minutes),2) as avg_min from users u2
	inner join usage_monthly um 
	on u2.user_id = um.user_id
where u2.signup_channel = u.signup_channel
group by u2.signup_channel) as avg_min from subscriptions s
	inner join users u
	on u.user_id = s.user_id
group by u.signup_channel
order by perc_gone desc
