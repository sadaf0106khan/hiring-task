create or replace function max_consecutive()
returns table(cid int, m int, c int)
language plpgsql
as
$$
declare 
rec record;
rec1 record;
count int;
temp_m int;
temp_y int;
max int;
sum int;
max_sum int;
begin 
for rec1 in select distinct rental.customer_id id from public.rental order by rental.customer_id
loop
count = 0;
max = 0;
sum = 0;
max_sum = 0;
for rec in select extract(year from rental.rental_date) y, extract(month from rental.rental_date) m, count(extract(month from rental.rental_date)) c from public.rental where rental.customer_id = rec1.id group by extract(year from rental.rental_date),extract(month from rental.rental_date)
loop
if count = 0 then 
sum = sum + rec.c;
count = count + 1;
elseif temp_m + 1 = rec.m and temp_y = rec.y then
sum = sum + rec.c;
count = count + 1;
elseif temp_m = 12 and rec.m = 1 and temp_y + 1 = rec.y then
sum = sum + rec.c;
count = count + 1;
else
if count > max then
max = count;
max_sum = sum;
end if;
count = 1;
sum = rec.c;
end if;
temp_m = rec.m;
temp_y = rec.y;
end loop;
if count > max then
max = count;
max_sum = sum;
end if;
cid:= rec1.id;
m:= max;
c:= max_sum;
return next;
end loop;
end;
$$
;
