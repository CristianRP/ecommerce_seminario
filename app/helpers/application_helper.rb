module ApplicationHelper
  # Helper to render a bootstrap card and passing a block
  def bootstrap_card(title, &block)
    content = capture(&block)
    content_tag(:div, nil, class: 'card shadow mb-4') {
      content_tag(:div, nil, class: 'card-header py-3') {
        content_tag(:h6, title, class: 'm-0 font-weight-bold text-primary')
      } + content_tag(:div, content, class: 'card-body')
    }
  end

  # Render themed text field 
  def bootstrap_text_field(form, attribute, placeholder = nil)
    form.text_field attribute, class: 'form-control', placeholder: placeholder
  end

  def bootstrap_btn_icon_split(css_class, text, icon, action = '')
    content_tag(:a, nil, class: "btn btn-sm btn-#{css_class} btn-icon-split", href: action) {
      content_tag(:span, nil, class: 'icon text-white-50') {
        content_tag(:i, nil, class: "fas fa-#{icon}")
      } + content_tag(:span, text, class: 'text')
    }
  end

  def bootstrap_btn_destroy_icon_split(model)
    content_tag(:a, nil, class: "btn btn-sm btn-danger btn-icon-split", 
      'data-method': :delete, rel: 'no-follow', href: url_for(model), 
      data: { :confirm => t('.confirm', :default => t("helpers.links.confirm", :default => 'Are you sure?'))}) {
      content_tag(:span, nil, class: 'icon text-white-50') {
        content_tag(:i, nil, class: "fas fa-trash")
      } + content_tag(:span, t('.destroy', :default => t("helpers.links.destroy")), class: 'text')
    }
  end

  def bootstrap_submit_icon_split(css_class, icon, &block)
    content = capture(&block)
    content_tag(:a, nil, class: "btn btn-sm btn-#{css_class} btn-icon-split", type: 'submit') {
      content_tag(:span, nil, class: 'icon text-white-50') {
        content_tag(:i, nil, class: "fas fa-#{icon}")
      } + content 
    }
  end

  def bootstrap_notice(text, css_class) 
    content_tag(:div, nil, class: "alert alert-#{css_class} alert-dismissible fade show", role: 'alert') {
      text.html_safe +
      content_tag(:button, nil, type: 'button', class: 'close', 'data-dismiss': 'alert', 'aria-label': 'Close') {
        content_tag(:span, '&times;'.html_safe, 'aria-hidden': true)
      }
    }
  end

  def bootstrap_error_alert(css_class, &block)
    content = capture(&block) 
    content_tag(:div, nil, class: "alert alert-#{css_class} alert-dismissible fade show", role: 'alert') {
      content +
      content_tag(:button, nil, type: 'button', class: 'close', 'data-dismiss': 'alert', 'aria-label': 'Close') {
        content_tag(:span, '&times;'.html_safe, 'aria-hidden': true)
      }
    }
  end

  def bootstrap_card_bordered(css_class, title, amount, icon) 
    content_tag(:div, nil, class: 'col-xl-3 col-md-6 mb-4') {
      content_tag(:div, nil, class: "card border-left-#{css_class} shadow h-100 py-2") {
        content_tag(:div, nil, class: 'card-body') {
          content_tag(:div, nil, class: 'row no-gutters align-items-center') {
            content_tag(:div, nil, class: 'col mr-2') {
              content_tag(:div, title, class: "text-xs font-weight-bold text-#{css_class} text-uppercase mb-1") +
              content_tag(:div, amount, class: 'h5 mb-0 font-weight-bold text-gray-800')
            } +
            content_tag(:div, nil, class: 'col-auto') {
              content_tag(:i, nil, class: "fas fa-#{icon} fa-2x text-gray-300")
            }
          }
        }
      }
    }
  end

  def date_format(date)
    date.strftime('%d/%m/%Y')
  end
end
