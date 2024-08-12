SELECT
  ad_types.name AS ad_type_name,
  AVG(ratings.rating) AS average_rating,
  COUNT(ratings.rating) AS rating_count,
  MAX(notices.created_at) AS ad_type_created_at
FROM
  notices
LEFT JOIN
  ratings ON ratings.notice_id = notices.id
INNER JOIN
  ad_types ON ad_types.id = notices.ad_type_id
GROUP BY
  ad_types.name;
