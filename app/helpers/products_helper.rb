module ProductsHelper

  def active(is_active)
    content_tag(:span, nil, nil) {
      content_tag(:i, nil, class: is_active ? 'fa fa-check' : 'fa fa-times', style: is_active ? 'color: green;' : 'color: red;')
    }
  end

end
