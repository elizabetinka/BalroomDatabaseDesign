EXPLAIN ANALYZE SELECT dc.categoryid,MIN(ps.stage),sum(pf.place_mark) as финал_сумма_баллов from dancerperson  as dp 
                                 JOIN dancer as d on d.manid = dp.personid OR d.ladyid = dp.personid
                                 JOIN dancernumber as dn on dn.dancerid = d.dancerid
                                 JOIN dancercategory as dc on dc.dancerid = d.dancerid
                                 JOIN category as c on c.categoryid = dc.categoryid  AND c.partid = dn.partid
                                 LEFT JOIN protocolstages as ps on ps.dancer_number = dn.dancer_number AND ps.categoryid = dc.categoryid
                                 LEFT JOIN protocolfinal as pf on pf.dancer_number = dn.dancer_number AND pf.categoryid = dc.categoryid
WHERE dp.personid=1
GROUP BY dc.categoryid