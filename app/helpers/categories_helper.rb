module CategoriesHelper
  def subcat_prefix(depth)
    ("&nbsp;" * 4 * depth).html_safe
  end

  def category_options_array(parent_id = nil, depth = 0, sorted_categs = [])
    categories = parent_id.nil? ? Category.primary : Category.where(parent_id: parent_id)

    categories.each do |category|
      sorted_categs << [subcat_prefix(depth) + category.name, category.id]
      category_options_array(category.id, depth + 1, sorted_categs)
    end

    sorted_categs
  end
end
