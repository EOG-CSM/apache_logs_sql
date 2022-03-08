create temp table popular_users as
(select foo.userid, email, accesses from (select userid, count(userid) as accesses from logs group by userid) as foo left join userid_to_id on foo.userid = userid_to_id.userid order by accesses desc);



\copy popular_users to 'popular_users.csv' csv header
