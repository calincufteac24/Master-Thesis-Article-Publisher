SELECT
    n.id AS notice_id,
    n.observation,
    atrt.body AS description,
    nv.value AS title
FROM
    notices n
LEFT JOIN
    action_text_rich_texts atrt ON atrt.record_id = n.id AND atrt.record_type = 'Notice' AND atrt.name = 'description'
LEFT JOIN
    ad_type_fields atf ON atf.name = 'Titlu'
LEFT JOIN
    notice_values nv ON nv.notice_id = n.id AND nv.ad_type_field_id = atf.id;
