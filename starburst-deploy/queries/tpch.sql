 CREATE SCHEMA hive.logistic WITH (location = 'gs://starburst-bluetab-test/logistic');

CREATE VIEW "hive"."logistic"."shipping_priority" SECURITY DEFINER AS
SELECT
  l.orderkey
, SUM((l.extendedprice * (1 - l.discount))) revenue
, o.orderdate
, o.shippriority
FROM
  tpch.tiny.customer c
, tpch.tiny.orders o
, tpch.tiny.lineitem l
WHERE ((c.mktsegment = 'BUILDING') AND (c.custkey = o.custkey) AND (l.orderkey = o.orderkey))
GROUP BY l.orderkey, o.orderdate, o.shippriority
ORDER BY revenue DESC, o.orderdate ASC;


CREATE VIEW "hive"."logistic"."minimum_cost_supplier" SECURITY DEFINER AS
SELECT
  s.acctbal
, s.name SupplierName
, n.name Nation
, p.partkey
, p.mfgr
, s.address
, s.phone
, s.comment
FROM
  tpch.tiny.part p
, tpch.tiny.supplier s
, tpch.tiny.partsupp ps
, tpch.tiny.nation n
, tpch.tiny.region r
WHERE ((p.partkey = ps.partkey) AND (s.suppkey = ps.suppkey) AND (p.size = 15) AND (p.type LIKE '%BRASS') AND (s.nationkey = n.nationkey) AND (n.regionkey = r.regionkey) AND (r.name = 'EUROPE') AND (ps.supplycost = (SELECT MIN(ps.supplycost)
FROM
  tpch.tiny.partsupp ps
, tpch.tiny.supplier s
, tpch.tiny.nation n
, tpch.tiny.region r
WHERE ((p.partkey = ps.partkey) AND (s.suppkey = ps.suppkey) AND (s.nationkey = n.nationkey) AND (n.regionkey = r.regionkey) AND (r.name = 'EUROPE'))
)))
ORDER BY s.acctbal DESC, n.name ASC, s.name ASC, p.partkey ASC;



select
  cst.name as CustomerName,
  cst.address,
  cst.phone,
  cst.nationkey,
  cst.acctbal as BookedOrders,
  cst.mktsegment,
  nat.name as Nation,
  reg.name as Region
from tpch.sf1.customer as cst
join tpch.sf1.nation as nat on nat.nationkey = cst.nationkey
join tpch.sf1.region as reg on reg.regionkey = nat.regionkey
where reg.regionkey = 1;

select
  nat.name as Nation,
  avg(cst.acctbal) as average_booking
from tpch.sf100.customer as cst
join tpch.sf100.nation as nat on nat.nationkey = cst.nationkey
join tpch.sf100.region as reg on reg.regionkey = nat.regionkey
where reg.regionkey = 1
group by nat.name;