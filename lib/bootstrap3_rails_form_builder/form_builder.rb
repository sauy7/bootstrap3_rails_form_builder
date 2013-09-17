module Bootstrap3RailsFormBuilder
  class FormBuilder < ActionView::Helpers::FormBuilder
    BUTTON_STYLES = %w{danger default info link primary success warning}

    FORM_HELPERS = %w{text_field password_field text_area file_field number_field email_field telephone_field
                      phone_field url_field select collection_select date_select time_select datetime_select
                      datetime_local_field month_field week_field range_field}

    delegate :content_tag, to: :@template
    delegate :capture, to: :@template

    def initialize(object_name, object, template, options={}, proc=nil)
      options[:html] = {} unless options.has_key?(:html)
      options[:html][:class] = set_form_css_class(options)

      help = options.fetch(:help, nil)
      @help_class = help.eql?(:block) ? 'help-block' : nil
      super
    end

    FORM_HELPERS.each do |method_name|
      define_method(method_name) do |name, *args|
        options = args.extract_options!.symbolize_keys!
        options[:class] ||= 'form-control'
        css_size = options.delete(:css_size) || ''
        options[:class] << case css_size
                             when :large
                               ' input-lg'
                             when :small
                               ' input-sm'
                             else
                               ''
                           end

        label = options.delete(:label)
        help  = options.delete(:help)
        hide_label = options.delete(:hide_label) ? 'sr-only' : nil

        form_group(name, label: { text: label, class: hide_label }, help: help) do
          case method_name
            when 'select', 'collection_select'
              select_options = [:include_blank, :prompt, :disabled]
              super(name, *args, options.extract!(*select_options) , options.except(*select_options))
            else
              args << options
              super(name, *args)
          end
        end
      end
    end

    def check_box(name, options = {}, checked_value = "1", unchecked_value = "0")
      options = options.symbolize_keys!

      html = super(name, options.except(:label, :help, :inline), checked_value, unchecked_value)
      html += ' ' + (options[:label] || name.to_s.humanize)

      css = 'checkbox'
      if options[:inline]
        css << '-inline'
        label(name, html, class: css)
      else
        content_tag(:div, label(name, html), class: css)
      end
    end

    def radio_button(name, value, *args)
      options = args.extract_options!.symbolize_keys!
      args << options.except(:label, :help, :inline)

      html = super(name, value, *args) + ' ' + options[:label]

      css = 'radio'
      if options[:inline]
        css << '-inline'
        label("#{name}_#{value}", html, class: css)
      else
        content_tag(:div, label(name, html), class: css)
      end
    end

    def static_control(name, *args)
      options = args.extract_options!.symbolize_keys!
      options[:class] ||= 'form-control-static'

      label = options.delete(:label)
      help  = options.delete(:help)

      form_group(name, label: { text: label, for: nil, class: "control-label" }, help: help) do
        content_tag(:p, object.send(name), options)
      end
    end

    def form_group(name = nil, options = {}, &block)
      errors_has_name = object.respond_to?(:errors) && !(name.nil? || object.errors[name].empty?)

      options[:class] ||= 'form-group'
      options[:class] << ' has-error' if errors_has_name

      label = options.delete(:label)
      _help = options.delete(:help)

      content_tag(:div, options) do
        html = ''

        if label && (label[:text] != :none && label[:text] != false)
          label[:for] ||= '' if name.nil?

          html << label(name, label[:text], label.except(:text))
        end

        html << capture(&block)

        help = errors_has_name ? object.errors[name].join(', ') : _help
        html << content_tag(:span, help, class: @help_class) if help

        html.html_safe
      end
    end

    def btn(name, options = {})
      css = "btn"
      css << " #{options[:class]}" if options[:class]
      css << " btn-block" if options.delete(:block)
      case options.delete(:size)
        when :large
          css << " btn-lg"
        when :small
          css << " btn-sm"
        when :xsmall
          css << " btn-xs"
      end
      options[:class] = css
      button name, options # Bootstrap recommends using <button> over <input type="submit">
    end

    BUTTON_STYLES.each do |btn_style|
      define_method(btn_style) do |name, *args|
        options = args.extract_options!.symbolize_keys!

        css = "btn-#{btn_style}"
        css << " #{options[:class]}" if options[:class]
        options[:class] = css
        btn name, options
      end
    end

    def alert_message(title, *args)
      options = args.extract_options!
      css = options[:class] || "alert alert-danger"

      if object.respond_to?(:errors) && object.errors.full_messages.any?
        content_tag :div, class: css do
          title
        end
      end
    end

    private

    def set_form_css_class(options)
      css = options[:html].fetch(:class, '')
      layout = options.fetch(:layout, '')
      layout = case layout
                 when :horizontal, :inline
                   "form-#{layout}"
                 else
                   ''
               end
      out = css.include?(layout) ? css : "#{css} #{layout}"
      out.strip
    end

  end
end