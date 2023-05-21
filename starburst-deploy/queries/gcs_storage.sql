drop table hive.datalake.customer;
drop table hive.datalake.orders;
drop table hive.datalake.supplier;
drop table hive.datalake.nation;
drop table hive.datalake.region_external;
drop table hive.datalake.region;
drop table hive.datalake.partitioned_nation;

drop schema hive.datalake;

CREATE SCHEMA hive.datalake WITH (location = 'gs://starburst-bluetab-test/datalake');

create table hive.datalake.customer WITH (format = 'ORC') as select * from tpch.sf100.customer;
create table hive.datalake.orders WITH (format = 'Parquet') as select * from tpch.sf100.orders;
create table hive.datalake.supplier WITH (format = 'ORC') as select * from tpch.sf100.supplier;
create table hive.datalake.nation WITH (format = 'ORC') as select * from tpch.sf100.nation;
create table hive.datalake.region as select * from tpch.sf100.region;

CREATE TABLE hive.datalake.region_external (
  regionkey bigint, name varchar(25), comment varchar(152)
)
WITH (
  external_location='gs://starburst-bluetab-test/datalake/region',
  format='orc'
);

select * from hive.datalake.region_external;

CREATE TABLE hive.datalake.partitioned_nation
WITH (
  partitioned_by = ARRAY['nationkey']
)
AS SELECT name, comment, regionkey, nationkey FROM tpch.sf1.nation;

select * from hive.datalake.partitioned_nation;

select * from hive.datalake.customer;
select count(*) from hive.datalake.orders;

select
    s.*,
    n.name as nation,
    r.name as region
from
    hive.datalake.supplier s
    join hive.datalake.nation n on s.nationkey = n.nationkey
    join hive.datalake.region r on r.regionkey = n.regionkey
    where r.name='EUROPE';

select
    r.name as region,
    sum(s.acctbal) as total_account_balance
from
    hive.datalake.supplier s
    join hive.datalake.nation n on s.nationkey = n.nationkey
    join hive.datalake.region r on r.regionkey = n.regionkey
group by r.name
order by total_account_balance;
