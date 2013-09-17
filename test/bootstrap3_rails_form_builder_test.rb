require_relative 'test_helper'

class Bootstrap3RailsFormBuilderTest < ActionView::TestCase
  include Bootstrap3RailsFormBuilder::Helper

  def setup
    @thing = Thing.new(email: 'another@example.com',
                       password: 'secret',
                       description: 'Lorem ipsum',
                       radio_options: 'one',
                       checkbox_option: 1,
                       file_name: 'avatar.jpg',
                       telephone_number: "012 345 6789",
                       url: 'http://example.com',
                       count: 3)
    @builder = Bootstrap3RailsFormBuilder::FormBuilder.new(:thing, @thing, self)
  end

  def things_path(options = {})
    '/things'
  end

  def year_options(selected = 2012)
    out = ""
    (2007..2017).each do |index|
      out << ((index == selected) ? %Q(<option selected="selected" value="#{index}">#{index}</option>\n) : %Q(<option value="#{index}">#{index}</option>\n))
    end
    out
  end

  def month_options(selected = 2)
    out = ""
    %w(January February March April May June July August September October November December).each_with_index do |month, index|
      out << ((index == selected - 1) ? %Q(<option selected="selected" value="#{index+1}">#{month}</option>\n) : %Q(<option value="#{index+1}">#{month}</option>\n))
    end
    out
  end

  def date_options(selected = 3)
    out = ""
    (1..31).each do |index|
      out << ((index == selected) ? %Q(<option selected="selected" value="#{index}">#{index}</option>\n) : %Q(<option value="#{index}">#{index}</option>\n))
    end
    out
  end

  def leading_zero_options(start = 0, max = 23, selected = 1)
    out = ""
    (start..max).each do |index|
      value = (index < 10) ? "0#{index}" : index
      out << ((index == selected) ? %Q(<option selected="selected" value="#{value}">#{value}</option>\n) : %Q(<option value="#{value}">#{value}</option>\n))
    end
    out
  end

  def hour_options
    leading_zero_options(0, 23, 12)
  end

  def minute_options
    leading_zero_options(0, 59, 0)
  end

  # bootstrap_form_for helper
  test "wraps a basic bootstrap form" do
    expected = %{<form accept-charset="UTF-8" action="/things" class="new_thing" id="new_thing" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div></form>}
    actual = bootstrap_form_for(@thing) { |f| nil }
    assert_dom_equal expected, actual
  end

  test "wraps a horizontal bootstrap form" do
    expected = %{<form accept-charset="UTF-8" action="/things" class="new_thing form-horizontal" id="new_thing" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div></form>}
    actual = bootstrap_form_for(@thing, layout: :horizontal) { |f| nil }
    assert_dom_equal expected, actual
  end

  test "wraps an inline bootstrap form" do
    expected = %{<form accept-charset="UTF-8" action="/things" class="new_thing form-inline" id="new_thing" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div></form>}
    actual = bootstrap_form_for(@thing, layout: :inline) { |f| nil }
    assert_dom_equal expected, actual
  end

  test "passing :help :block to the form builder" do
    actual = bootstrap_form_for(@thing, help: :block) do |f|
      f.text_field(:email, help: 'This is required')
    end
    expected = %{<form accept-charset="UTF-8" action="/things" class="new_thing" id="new_thing" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><label for="thing_email">Email</label><input class="form-control" id="thing_email" name="thing[email]" type="text" value="another@example.com" /><span class="help-block">This is required</span></div></form>}
    assert_dom_equal expected, actual
  end

  test "bootstrap_form_for helper works for associations" do
    @thing.majig = Majig.new(foo: 'bar')

    actual = bootstrap_form_for(@thing) do |f|
      f.fields_for :majig do |af|
        af.text_field(:foo)
      end
    end

    expected = %{<form accept-charset="UTF-8" action="/things" class="new_thing" id="new_thing" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><label for="thing_majig_attributes_foo">Foo</label><input class="form-control" id="thing_majig_attributes_foo" name="thing[majig_attributes][foo]" type="text" value="bar" /></div></form>}
    assert_dom_equal expected, actual
  end

  # form field helpers
  test "text fields are wrapped correctly" do
    expected = %{<div class="form-group"><label for="thing_email">Email</label><input class="form-control" id="thing_email" name="thing[email]" type="text" value="another@example.com" /></div>}
    actual = @builder.text_field(:email)
    assert_dom_equal expected, actual
  end

  test "password fields are wrapped correctly" do
    expected = %{<div class="form-group"><label for="thing_password">Password</label><input class="form-control" id="thing_password" name="thing[password]" type="password" /></div>}
    actual = @builder.password_field(:password)
    assert_dom_equal expected, actual
  end

  test "text areas are wrapped correctly" do
    expected = %{<div class="form-group"><label for="thing_description">Description</label><textarea class="form-control" id="thing_description" name="thing[description]">\nLorem ipsum</textarea></div>}
    actual = @builder.text_area(:description)
    assert_dom_equal expected, actual
  end

  test "file fields are wrapped correctly" do
    expected = %{<div class="form-group"><label for="thing_file_name">File name</label><input class="form-control" id="thing_file_name" name="thing[file_name]" type="file" /></div>}
    actual = @builder.file_field(:file_name)
    assert_dom_equal expected, actual
  end

  test "number fields with relevant options are wrapped correctly" do
    @thing.count = 10
    expected = %{<div class="form-group"><label for="thing_count">Count</label><input class="form-control" id="thing_count" max="100" min="0" name="thing[count]" step="10" type="number" value="10" /></div>}
    actual = @builder.number_field(:count, min: 0, max: 100, step: 10)
    assert_dom_equal expected, actual
  end

  test "email fields are wrapped correctly" do
    expected = %{<div class="form-group"><label for="thing_email">Email</label><input class="form-control" id="thing_email" name="thing[email]" type="email" value="another@example.com" /></div>}
    actual = @builder.email_field(:email)
    assert_dom_equal expected, actual
  end

  test "telephone/phone fields are wrapped correctly" do
    expected = %{<div class="form-group"><label for="thing_telephone_number">Telephone number</label><input class="form-control" id="thing_telephone_number" name="thing[telephone_number]" type="tel" value="012 345 6789" /></div>}
    actual = @builder.telephone_field(:telephone_number)
    assert_dom_equal expected, actual
    actual = @builder.phone_field(:telephone_number)
    assert_dom_equal expected, actual
  end

  test "url fields are wrapped correctly" do
    expected = %{<div class="form-group"><label for="thing_url">Url</label><input class="form-control" id="thing_url" name="thing[url]" type="url" value="http://example.com" /></div>}
    actual = @builder.url_field(:url)
    assert_dom_equal expected, actual
  end

  test "selects are wrapped correctly" do
    expected = %{<div class="form-group"><label for="thing_choice">Choice</label><select class="form-control" id="thing_choice" name="thing[choice]"><option value="a">A</option>\n<option value="b">B</option></select></div>}
    actual = @builder.select(:choice, [['A', 'a'], ['B', 'b']])
    assert_dom_equal expected, actual
  end

  test "selects support include_blank option" do
    expected = %{<div class="form-group"><label for="thing_choice">Choice</label><select class="form-control" id="thing_choice" name="thing[choice]"><option value=""></option>\n<option value="a">A</option>\n<option value="b">B</option></select></div>}
    actual = @builder.select(:choice, [['A', 'a'], ['B', 'b']], include_blank: true)
    assert_dom_equal expected, actual
  end

  test "selects support include_blank option with text" do
    expected = %{<div class="form-group"><label for="thing_choice">Choice</label><select class="form-control" id="thing_choice" name="thing[choice]"><option value="">None</option>\n<option value="a">A</option>\n<option value="b">B</option></select></div>}
    actual = @builder.select(:choice, [['A', 'a'], ['B', 'b']], include_blank: 'None')
    assert_dom_equal expected, actual
  end

  test "selects support prompt option with text" do
    expected = %{<div class="form-group"><label for="thing_choice">Choice</label><select class="form-control" id="thing_choice" name="thing[choice]"><option value="">Select one</option>\n<option value="a">A</option>\n<option value="b">B</option></select></div>}
    actual = @builder.select(:choice, [['A', 'a'], ['B', 'b']], prompt: 'Select one')
    assert_dom_equal expected, actual
  end

  test "selects support prompt option with text when option selected" do
    @thing.choice = 'a'
    expected = %{<div class="form-group"><label for="thing_choice">Choice</label><select class="form-control" id="thing_choice" name="thing[choice]"><option selected="selected" value="a">A</option>\n<option value="b">B</option></select></div>}
    actual = @builder.select(:choice, [['A', 'a'], ['B', 'b']], prompt: 'Select one')
    assert_dom_equal expected, actual
  end

  test "selects support disabled option" do
    expected = %{<div class="form-group"><label for="thing_choice">Choice</label><select class="form-control" id="thing_choice" name="thing[choice]"><option value="a">A</option>\n<option disabled="disabled" value="b">B</option></select></div>}
    actual = @builder.select(:choice, [['A', 'a'], ['B', 'b']], disabled: 'b')
    assert_dom_equal expected, actual
  end

  test "collection selects are wrapped correctly" do
    expected = %{<div class="form-group"><label for="thing_choice">Choice</label><select class="form-control" id="thing_choice" name="thing[choice]"><option value="a">A</option>\n<option value="b">B</option></select></div>}
    actual = @builder.collection_select(:choice, [OpenStruct.new(name: 'A', id: 'a'), OpenStruct.new(name: 'B', id: 'b')], :id, :name)
    assert_dom_equal expected, actual
  end

  test "date selects are wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3)) do
      expected = %{<div class="form-group"><label for="thing_my_date">My date</label><select id="thing_my_date_1i" name="thing[my_date(1i)]">\n#{year_options}</select>\n<select id="thing_my_date_2i" name="thing[my_date(2i)]">\n#{month_options}</select>\n<select id="thing_my_date_3i" name="thing[my_date(3i)]">\n#{date_options}</select>\n</div>}
      actual = @builder.date_select(:my_date)
      assert_dom_equal expected, actual
    end
  end

  test "time selects are wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = %{<div class="form-group"><label for="thing_my_time">My time</label><input id="thing_my_time_1i" name="thing[my_time(1i)]" type="hidden" value="2012" />\n<input id="thing_my_time_2i" name="thing[my_time(2i)]" type="hidden" value="2" />\n<input id="thing_my_time_3i" name="thing[my_time(3i)]" type="hidden" value="3" />\n<select id="thing_my_time_4i" name="thing[my_time(4i)]">\n#{hour_options}</select>\n : <select id="thing_my_time_5i" name="thing[my_time(5i)]">\n#{minute_options}</select>\n</div>}
      actual = @builder.time_select(:my_time)
      assert_dom_equal expected, actual
    end
  end

  test "datetime selects are wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = %{<div class="form-group"><label for="thing_my_datetime">My datetime</label><select id="thing_my_datetime_1i" name="thing[my_datetime(1i)]">\n#{year_options}</select>\n<select id="thing_my_datetime_2i" name="thing[my_datetime(2i)]">\n#{month_options}</select>\n<select id="thing_my_datetime_3i" name="thing[my_datetime(3i)]">\n#{date_options}</select>\n &mdash; <select id="thing_my_datetime_4i" name="thing[my_datetime(4i)]">\n#{hour_options}</select>\n : <select id="thing_my_datetime_5i" name="thing[my_datetime(5i)]">\n#{minute_options}</select>\n</div>}
      actual = @builder.datetime_select(:my_datetime)
      assert_dom_equal expected, actual
    end
  end

  test "datetime_local_field is wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3, 12, 0, 0)) do
      @thing.my_datetime = DateTime.now
      expected = %{<div class="form-group"><label for="thing_my_datetime">My datetime</label><input class="form-control" id="thing_my_datetime" name="thing[my_datetime]" type="datetime-local" value="2012-02-03T12:00:00" /></div>}
      actual = @builder.datetime_local_field(:my_datetime)
      assert_dom_equal expected, actual
    end
  end

  test "month_field is wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3, 12, 0, 0)) do
      @thing.my_datetime = DateTime.now
      expected = %{<div class="form-group"><label for="thing_my_datetime">My datetime</label><input class="form-control" id="thing_my_datetime" name="thing[my_datetime]" type="month" value="2012-02" /></div>}
      actual = @builder.month_field(:my_datetime)
      assert_dom_equal expected, actual
    end
  end

  test "week_field is wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3, 12, 0, 0)) do
      @thing.my_datetime = DateTime.now
      expected = %{<div class="form-group"><label for="thing_my_datetime">My datetime</label><input class="form-control" id="thing_my_datetime" name="thing[my_datetime]" type="week" value="2012-W05" /></div>}
      actual = @builder.week_field(:my_datetime)
      assert_dom_equal expected, actual
    end
  end

  test "range_field takes relevant options is wrapped correctly" do
    @thing.count = 10
    expected = %{<div class="form-group"><label for="thing_count">Count</label><input class="form-control" id="thing_count" max="100" min="0" name="thing[count]" step="10" type="range" value="10" /></div>}
    actual = @builder.range_field(:count, in: 0..100, step: 10)
    assert_dom_equal expected, actual
  end

  test "check_box is wrapped correctly" do
    expected = %{<div class="checkbox"><label for="thing_checkbox_option"><input name="thing[checkbox_option]" type="hidden" value="0" /><input checked="checked" id="thing_checkbox_option" name="thing[checkbox_option]" type="checkbox" value="1" /> Checkbox option</label></div>}
    actual = @builder.check_box(:checkbox_option)
    assert_dom_equal expected, actual
  end

  test "check_box responds to checked_value and unchecked_value arguments" do
    expected = %{<div class="checkbox"><label for="thing_checkbox_option"><input name="thing[checkbox_option]" type="hidden" value="no" /><input checked="checked" id="thing_checkbox_option" name="thing[checkbox_option]" type="checkbox" value="yes" /> Checkbox option</label></div>}
    actual = @builder.check_box(:checkbox_option, {}, 'yes', 'no')
    assert_dom_equal expected, actual
  end

  test "check_box responds to label option" do
    expected = %{<div class="checkbox"><label for="thing_checkbox_option"><input name="thing[checkbox_option]" type="hidden" value="0" /><input checked="checked" id="thing_checkbox_option" name="thing[checkbox_option]" type="checkbox" value="1" /> Alternative label</label></div>}
    actual = @builder.check_box(:checkbox_option, label: "Alternative label")
    assert_dom_equal expected, actual
  end

  test "check_box inline label is set correctly" do
    expected = %{<label class="checkbox-inline" for="thing_checkbox_option"><input name="thing[checkbox_option]" type="hidden" value="0" /><input checked="checked" id="thing_checkbox_option" name="thing[checkbox_option]" type="checkbox" value="1" /> Checkbox option</label>}
    actual = @builder.check_box(:checkbox_option, inline: true)
    assert_dom_equal expected, actual
  end

  test "radio_button is wrapped correctly" do
    expected = %{<div class="radio"><label for="thing_radio_options"><input checked="checked" id="thing_radio_options_one" name="thing[radio_options]" type="radio" value="one" /> One</label></div>}
    actual = @builder.radio_button(:radio_options, 'one', { label: "One" })
    assert_dom_equal expected, actual
  end

  test "radio_button inline label is set correctly" do
    expected = %{<label class="radio-inline" for="thing_radio_options_one"><input checked="checked" id="thing_radio_options_one" name="thing[radio_options]" type="radio" value="one" /> One</label>}
    actual = @builder.radio_button(:radio_options, 'one', label: 'One', inline: true)
    assert_dom_equal expected, actual
  end

  test "static control" do
    expected = %{<div class="form-group"><label class="control-label">Email</label><p class="form-control-static">another@example.com</p></div>}
    actual = @builder.static_control(:email)
    assert_dom_equal expected, actual
  end

  # form field helper variations
  test "passing :help to a field displays it inline" do
    expected = %{<div class="form-group"><label for="thing_email">Email</label><input class="form-control" id="thing_email" name="thing[email]" type="text" value="another@example.com" /><span>This is required</span></div>}
    actual = @builder.text_field(:email, help: 'This is required')
    assert_dom_equal expected, actual
  end

  test "passing other options to a field get passed through" do
    expected = %{<div class="form-group"><label for="thing_email">Email</label><input autofocus="autofocus" class="form-control" id="thing_email" name="thing[email]" type="text" value="another@example.com" /></div>}
    actual = @builder.text_field(:email, autofocus: true)
    assert_dom_equal expected, actual
  end

  test "changing the label text" do
    expected = %{<div class="form-group"><label for="thing_email">Email Address</label><input class="form-control" id="thing_email" name="thing[email]" type="text" value="another@example.com" /></div>}
    actual = @builder.text_field(:email, label: 'Email Address')
    assert_dom_equal expected, actual
  end

  test "hide labels with sr-only class for inline forms" do
    expected = %{<div class="form-group"><label class="sr-only" for="thing_email">Email</label><input class="form-control" id="thing_email" name="thing[email]" type="text" value="another@example.com" /></div>}
    actual = @builder.text_field(:email, hide_label: true)
    assert_dom_equal expected, actual
  end

  test "render the field without label" do
    expected = %{<div class="form-group"><input class="form-control" id="thing_email" name="thing[email]" type="text" value="another@example.com" /></div>}
    actual = @builder.text_field(:email, label: :none)
    assert_dom_equal expected, actual
    actual = @builder.text_field(:email, label: false)
    assert_dom_equal expected, actual
  end

  test "large form fields" do
    expected = %{<div class="form-group"><label for="thing_email">Email</label><input class="form-control input-lg" id="thing_email" name="thing[email]" type="text" value="another@example.com" /></div>}
    actual = @builder.text_field(:email, css_size: :large)
    assert_dom_equal expected, actual
  end

  test "small form fields" do
    expected = %{<div class="form-group"><label for="thing_choice">Choice</label><select id="thing_choice" class="form-control input-sm" name="thing[choice]"><option value="a">A</option>\n<option value="b">B</option></select></div>}
    actual = @builder.select(:choice, [['A', 'a'], ['B', 'b']], css_size: :small)
    assert_dom_equal expected, actual
  end


  # form-group
  test "form_group creates a valid structure and allows arbitrary html to be added via a block" do
    actual = @builder.form_group do
      content_tag(:span, 'custom control here')
    end
    expected = %{<div class="form-group"><span>custom control here</span></div>}
    assert_dom_equal expected, actual
  end

  test "form_group renders the options for div.form_group" do
    actual = @builder.form_group nil, id: 'foo' do
      content_tag(:span, 'custom control here')
    end

    expected = %{<div class="form-group" id="foo"><span>custom control here</span></div>}
    assert_dom_equal expected, actual
  end

  test "form_group overrides the form-group class if another is passed" do
    actual = @builder.form_group nil, class: 'foo' do
      content_tag(:span, 'custom control here')
    end

    expected = %{<div class="foo"><span>custom control here</span></div>}
    assert_dom_equal expected, actual
  end

  test "form_group renders the label correctly" do
    actual = @builder.form_group :email, label: { text: 'Custom Control' } do
      content_tag(:span, 'custom control here')
    end

    expected = %{<div class="form-group"><label for="thing_email">Custom Control</label><span>custom control here</span></div>}
    assert_dom_equal expected, actual
  end

  test "form_group overrides the label's 'class' and 'for' attributes if others are passed" do
    actual = @builder.form_group nil, label: { text: 'Custom Control', class: 'foo', for: 'bar' } do
      content_tag(:span, 'custom control here')
    end

    expected = %{<div class="form-group"><label class="foo" for="bar">Custom Control</label><span>custom control here</span></div>}
    assert_dom_equal expected, actual
  end

  test "form_group label's 'for' attribute should be empty if no name was passed" do
    actual = @builder.form_group nil, label: { text: 'Custom Control' } do
      content_tag(:span, 'custom control here')
    end

    expected = %{<div class="form-group"><label for="">Custom Control</label><span>custom control here</span></div>}
    assert_dom_equal expected, actual
  end

  test 'form_group renders the :help correctly' do
    actual = @builder.form_group nil, help: 'Helpful hint' do
      content_tag(:span, 'custom control here')
    end

    expected = %{<div class="form-group"><span>custom control here</span><span>Helpful hint</span></div>}
    assert_dom_equal expected, actual
  end

  test "form_group renders the 'error' class and message correctly when object is invalid" do
    @thing.email = nil
    @thing.valid?

    actual = @builder.form_group :email do
      content_tag(:span, 'custom control here')
    end

    expected = %{<div class="form-group has-error"><span>custom control here</span><span>can&#39;t be blank, is too short (minimum is 5 characters)</span></div>}
    assert_dom_equal expected, actual
  end

  # buttons
  test "primary button contains the correct classes" do
    expected = %{<button class="btn btn-primary" name="button" type="submit">Submit</button>}
    actual = @builder.primary('Submit')
    assert_dom_equal expected, actual
  end

  test "xsmall, block info button contains the correct classes" do
    expected = %{<button class="btn btn-info btn-block btn-xs" name="button" type="submit">Info</button>}
    actual = @builder.info('Info', block: true, size: :xsmall)
    assert_dom_equal expected, actual
  end

  test "large danger button contains the correct classes" do
    expected = %{<button class="btn btn-danger btn-lg" name="button" type="submit">Delete</button>}
    actual = @builder.danger('Delete', size: :large)
    assert_dom_equal expected, actual
  end

  test "default reset button contains the correct classes and type" do
    expected = %{<button class="btn btn-default" name="button" type="reset">Reset</button>}
    actual = @builder.default("Reset", type: "reset")
    assert_dom_equal expected, actual
  end

  test "link button contains the correct classes" do
    expected = %{<button class="btn btn-link" name="button" type="submit">Link</button>}
    actual = @builder.link("Link")
    assert_dom_equal expected, actual
  end

  test "small warning button contains the correct classes" do
    expected = %{<button class="btn btn-warning btn-sm" name="button" type="submit">Warning</button>}
    actual = @builder.warning('Warning', size: :small)
    assert_dom_equal expected, actual
  end

  test "success button with extra class and id contains the correct attributes" do
    expected = %{<button class="btn btn-success my_class" id="my_id" name="button" type="submit">Success</button>}
    actual = @builder.success('Success', class: "my_class", id: "my_id")
    assert_dom_equal expected, actual
  end

  # alert message
  test "alert message is wrapped correctly" do
    @thing.email = nil
    @thing.valid?

    expected = %{<div class="alert alert-danger">Please fix the following errors:</div>}
    actual = @builder.alert_message('Please fix the following errors:')
    assert_dom_equal expected, actual
  end

  test "changing the class name for the alert message" do
    @thing.email = nil
    @thing.valid?

    expected = %{<div class="my-css-class">Please fix the following errors:</div>}
    actual = @builder.alert_message('Please fix the following errors:', class: 'my-css-class')
    assert_dom_equal expected, actual
  end

=begin
  # control sizing
  # control states
  # column sizing
  # disabled fieldsets
  # input groups
=end
end
