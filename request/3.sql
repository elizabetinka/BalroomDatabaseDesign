EXPLAIN ANALYZE WITH t1 AS (
    SELECT  c.categoryid,pf.dancer_number,min(pf.place_mark) as min from category as c JOIN protocolfinal as pf on pf.categoryid = c.categoryid
    GROUP BY c.categoryid,pf.dancer_number
   ), t2 AS (
    SELECT  c.categoryid,pf.dancer_number,SUM(pf.place_mark) as total from category as c JOIN protocolfinal as pf on pf.categoryid = c.categoryid
    GROUP BY c.categoryid,pf.dancer_number
   )
SELECT  t2.categoryid,t2.dancer_number from t2
    WHERE t2.total = (SELECT t1.min from t1  where t1.categoryid = t2.categoryid LIMIT 1)
    GROUP BY t2.categoryid,t2.dancer_number