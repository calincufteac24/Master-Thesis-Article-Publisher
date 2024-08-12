ActionView::Base.field_error_proc = proc do |html_tag, instance|
  class_attr_index = html_tag.index 'class="'

  if html_tag =~ /^<label/
    tag = html_tag
  else
    tag =
      if class_attr_index
        html_tag.insert class_attr_index + 7, 'is-invalid '
      else
        html_tag.insert html_tag.index('>'), ' class="is-invalid"'
      end
    tag += %(<label for="#{instance.send(:tag_id)}" class="text-danger">#{instance.error_message.first.capitalize}</label>).html_safe
  end

  tag
end
