module ApplicationHelper
  # Helper to render a bootstrap card and passing a block
  def bootstrap_card(title, &block)
    content = capture(&block)
    content_tag(:div, nil, class: 'panel panel-default') {
      content_tag(:div, title, class: 'panel-heading') +
        content_tag(:div, content, class: 'panel-body')
    }
  end

  def bootstrap_card_collapse(title, &block)
    content = capture(&block)
    content_tag(:div, nil, class: 'panel panel-default') {
      content_tag(:div, nil, class: 'panel-heading') {
        content_tag(:a, nil, class: 'pull-right', 'data-toggle': :tooltip, 'data-tool': 'panel-collapse', href: '#', title: title) {
          content_tag(:em, nil, class: 'fa fa-minus')
        } +
        content_tag(:div, title, class: 'panel-title')
      } +
      content_tag(:div, content, class: 'panel-body')
    }
  end

  # Render themed text field 
  def bootstrap_text_field(form, attribute, placeholder = nil)
    form.text_field attribute, class: 'form-control', placeholder: placeholder
  end

  def bootstrap_button(css_class, text, icon, action = '', method = '')
    content_tag(:a, nil, class: "btn btn-sm btn-#{css_class}", href: action, 'data-method': method) {
      content_tag(:i, nil, class: "fa fa-#{icon}") +
      content_tag(:span, text, class: 'text')
    }
  end

  def bootstrap_button_id(id, css_class, text, icon, action = '', method = '')
    content_tag(:a, nil, class: "btn btn-sm btn-#{css_class}", href: action, 'data-method': method, id: id, target: 'blank') {
      content_tag(:i, nil, class: "fa fa-#{icon}") +
      content_tag(:span, text, class: 'text')
    }
  end

  def bootstrap_button_ids(id, css_class, text, icon, action = '', method = '')
    content_tag(:a, nil, class: "btn btn-sm btn-#{css_class}", href: action, 'data-method': method, id: id) {
      content_tag(:i, nil, class: "fa fa-#{icon}") +
      content_tag(:span, text, class: 'text')
    }
  end

  def bootstrap_button_destroy(model)
    content_tag(:a, nil, class: "btn btn-sm btn-danger", 
      'data-method': :delete, rel: 'no-follow', href: url_for(model), 
      data: { confirm: t('.confirm', default: t("helpers.links.confirm", default: 'Are you sure?'))}) {
      content_tag(:i, nil, class: "fa fa-trash") + 
      content_tag(:span, t('.destroy', default: t("helpers.links.destroy")), class: 'text')
    }
  end

  def bootstrap_submit_button(form, text)
    #content_tag(:input, nil, class: "btn btn-sm btn-success", type: 'submit', name: 'commit', value: "<span class='fa fa-plus'>#{text}</span>".html_safe, 'data-disable-with': text) 
    form.submit text, class: "btn btn-sm btn-success"
  end

  def bootstrap_notice(text, css_class) 
    content_tag(:div, nil, class: "alert alert-#{css_class} alert-dismissible fade in", role: 'alert') {
      content_tag(:button, nil, type: 'button', class: 'close', 'data-dismiss': 'alert', 'aria-label': 'Close') {
        content_tag(:span, '&times;'.html_safe, 'aria-hidden': true)
      } +
      text.html_safe 
    }
  end

  def bootstrap_error_alert(css_class, &block)
    content = capture(&block) 
    content_tag(:div, nil, class: "alert alert-#{css_class} alert-dismissible fade in", role: 'alert') {
      content_tag(:button, nil, type: 'button', class: 'close', 'data-dismiss': 'alert', 'aria-label': 'Close') {
        content_tag(:span, '&times;'.html_safe, 'aria-hidden': true)
      } +
      content
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

  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end
end
