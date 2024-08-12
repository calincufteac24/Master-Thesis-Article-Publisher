module NoticesHelper
  def notice_field_html_input(form, field)
    case field.form_field_type.to_sym
    when :text
      form.text_field(:value, class: 'form-control', placeholder: field.help_text)
    when :date
      current_date = Time.now.strftime("%d-%m-%Y") # Format as per your datepicker
      form.text_field(:value, class: 'form-control', data: { toggle: 'datepicker' }, placeholder: field.help_text, autocomplete: 'on', value: current_date)
    when :time
      current_time = Time.now.strftime("%H:%M") # Format as per your timepicker
      form.time_field(:value, class: 'form-control', data: { toggle: 'timepicker' }, placeholder: field.help_text, value: current_time)
    when :cpv
      form.number_field(:value, class: 'form-control', placeholder: field.help_text)
    when :file
      render(partial: 'notices/fields/file_field', locals: { form: form, field: field })
    when :options
      form.select(:value, field.option_values, {}, class: 'form-select')
    end
  end

  def notice_ad_type_select_options(notice)
    result = category_options_array.map do |category_name, category_id|
      [
        category_name,
        AdType.where(category_id: category_id).pluck(:name, :id)
      ]
    end
    grouped_options_for_select(result, notice.ad_type_id)
    # AdType.all.pluck(:name, :id)
  end

  def just_created?(record)
    record.status == 'draft' && record.created_at >= 30 .minutes.ago
  end
end
