{% test date_format_check(model, column_name, format_pattern='yyyy-mm-dd hh:mi:ss', extra_condition='1=1') %}

with validation as (

    select
        try_to_date({{ column_name }}, '{{ format_pattern }}') as convert_date

    from {{ model }}

    where {{ extra_condition }}

),

validation_errors as (

    select
        convert_date

    from validation
    where convert_date is null

)

select *
from validation_errors

{% endtest %}