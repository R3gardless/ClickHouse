create view paramview as select * from system.numbers where number <= {top:UInt64};

describe paramview; -- { serverError UNSUPPORTED_METHOD }
describe paramview(top = 10);
describe paramview(top = 2 + 2);

create view p2 as select number, {name:String} from system.numbers where number <= {top:UInt64};
describe p2(top = 10); -- { serverError UNKNOWN_QUERY_PARAMETER }
describe p2(name = 'Biba', top = 2);

create view p3 as select CAST(dummy, {t:String});
describe p3(t = 'Int');
describe p3(t = 'String');

describe (SELECT * FROM p3(t = 'Int64') union all SELECT * FROM p3(t = 'UInt64')); -- { serverError NO_COMMON_TYPE }

SELECT * FROM p3(t = 'String');

select arrayReduce('sum', (select groupArray(number) from paramview(top=10)));

create view test_pv as select number from numbers({limit:UInt64});
with (select sum(number) from test_pv(limit=10)) as sm select sm;
