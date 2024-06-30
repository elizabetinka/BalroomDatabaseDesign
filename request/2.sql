EXPLAIN ANALYZE SELECT part.partid,count(DISTINCT ticket.ticket_token) from ticket RIGHT JOIN part on part.partid = ticket.partid
GROUP BY part.partid
ORDER BY count(DISTINCT ticket.ticket_token) desc
limit 3