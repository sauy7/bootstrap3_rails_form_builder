module Bootstrap3RailsFormBuilder
  module Helper
    # A customised Rails form builder.
    #
    # It acts like the standard Rails form_for helper but adds some additional options -
    # * <tt>:layout</tt> - Specify `:horizontal` or `:inline` for Bootstrap 3 form layouts
    # * <tt>:help</tt> - Specify `:block` to render help text beneath form fields e.g.
    #
    #   <input type="text" ...>
    #   <span class="help-block">...</span>
    #
    # See: http://getbootstrap.com/css/#forms-help-text
    def bootstrap_form_for(object, options = {}, &block)
      options[:builder] = Bootstrap3RailsFormBuilder::FormBuilder

      disable_field_error_proc do
        form_for(object, options, &block)
      end
    end

    def set_form_css_class(options)

    end

    # Temporarily override Rails' field wrapping error code
    def disable_field_error_proc
      original_proc = ActionView::Base.field_error_proc
      ActionView::Base.field_error_proc = proc { |input, instance| input }
      yield
    ensure
      ActionView::Base.field_error_proc = original_proc
    end
  end
end
