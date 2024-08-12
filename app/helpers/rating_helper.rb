module RatingHelper
  def star_rating(rating)
    rounded_rating = rating.round
    full_star = content_tag(:i, '', class: 'fa fa-star text-warning')
    empty_star = content_tag(:i, '', class: 'fa fa-star text-secondary')

    colored_stars = (full_star * rounded_rating)
    empty_stars = (empty_star * (5 - rounded_rating))

    (colored_stars + empty_stars).html_safe
  end
end
