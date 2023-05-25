create schema postgres.logistic;
create table postgres.logistic.nation as select * from tpch.sf1.nation;

select
  cst.name as CustomerName,
  cst.address,
  cst.phone,
  cst.nationkey,
  cst.acctbal as BookedOrders,
  cst.mktsegment,
  nat.name as Nation,
  reg.name as Region
from hive.datalake.customer as cst
join postgres.logistic.nation as nat on nat.nationkey = cst.nationkey
join tpch.sf1.region as reg on reg.regionkey = nat.regionkey
where reg.regionkey = 1;