module Admin
  module AuditHelper
    def audit_message(audit)
      if audit.auditable.present?
        model = t("articulated_model_names.#{audit.auditable_type.tableize}", count: 1)
        url = link_to("##{audit.auditable.id}", audit.auditable)
      else
        url = audit.audited_changes.symbolize_keys.slice(:first_name, :last_name, :name).values.join(', ')
        model =
          if url.empty?
            t("some_model_names.#{audit.auditable_type.tableize}", count: 1)
          else
            t("articulated_model_names.#{audit.auditable_type.tableize}", count: 1)
          end
      end

      t("audit.actions.#{audit.action}_html",
        model: model,
        url: url,
        by: audit.user.present? ? t('audit.by', user_name: audit.user.name) : '')
    end

    def display_audit_changes(key, value)
      content_tag(:div, class: 'd-flex gap-1') do
        concat content_tag(:div, "<b> #{t("audits.audited_changes.#{key}")}: </b>".html_safe)
        if value.is_a?(Array)
          before = format_value(key, value[0])
          after = format_value(key, value[1])
          concat content_tag(:div, before, class: 'text-danger')
          concat content_tag(:div, '-', class: 'mx-1')
          concat content_tag(:div, after, class: 'text-success')
        else
          concat content_tag(:div, format_date(value), class: '')
        end
      end
    end

    def format_date(value)
      if valid_datetime_format?(value)
        parsed_date = DateTime.parse(value)
        parsed_date.strftime('%d/%m/%Y %H:%M')
      else
        t("audits.audit_values.#{value}")
      end
    rescue ArgumentError, TypeError
      value
    end

    def valid_datetime_format?(value)
      DateTime.iso8601(value)
      true
    rescue ArgumentError
      false
    end

    def format_value(key, value)
      if key == 'status'
        t("status.#{Notice.statuses.key(value)}") || value
      else
        value
      end
    end
  end
end
