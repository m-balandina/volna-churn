-- Завершения по месяцам.

select strftime('%Y-%m', s.ended_on) as date_unsub,
count(s.subscription_id) as unsubs from subscriptions s
where s.ended_on is not null
group by date_unsub
order by date_unsub asc
