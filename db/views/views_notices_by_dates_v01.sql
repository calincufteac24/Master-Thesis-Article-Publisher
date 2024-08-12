SELECT
    notices.id AS notice_id,
    notice_values.value AS date_value
FROM
    notices
INNER JOIN
    notice_values ON notice_values.notice_id = notices.id
INNER JOIN
    ad_type_fields ON ad_type_fields.id = notice_values.ad_type_field_id
WHERE
    ad_type_fields.form_field_type = 1
ORDER BY
    to_date(notice_values.value, 'DD-MM-YYYY') DESC NULLS LAST;
