SELECT
  c.name AS category_name,
  nv.value AS notice_title,
  n.price,
  n.created_at
FROM
  notices n
JOIN
  ad_types a ON n.ad_type_id = a.id
JOIN
  categories c ON a.category_id = c.id
JOIN
  notice_values nv ON n.id = nv.notice_id
JOIN
  ad_type_fields atf ON nv.ad_type_field_id = atf.id
WHERE
  n.price != 0.00
  AND atf.name = 'Titlu'
ORDER BY
  c.name;
