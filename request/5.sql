EXPLAIN ANALYZE select dancer_number, COUNT(cross_mark) from protocolstages
WHERE dance = :'dance' AND cross_mark
GROUP BY dancer_number