module ApplicationHelper
  # Converts Rails flash types to Bootstrap alert classes
  def bootstrap_class_for_flash(flash_type)
    case flash_type.to_sym
    when :notice
      "alert-success"
    when :alert
      "alert-warning"
    when :error
      "alert-danger"
    else
      "alert-info"
    end
  end
end
