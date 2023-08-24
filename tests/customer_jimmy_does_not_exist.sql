-- in dbt a Test fails if the SELECT returns any rows.
-- so this test verifies that no Customer named Jimmy exists

select * 
from  {{ ref('customers') }} 
where first_name = 'Jimmy'