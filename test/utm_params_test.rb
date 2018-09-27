require_relative "test_helper"

class UtmParamsMailer < ApplicationMailer
  track utm_params: true, except: [:welcome]

  def welcome
    mail_html('<a href="https://example.org">Test</a>')
  end

  def basic
    mail_html('<a href="https://example.org">Test</a>')
  end

  def array_params
    mail_html('<a href="https://example.org?baz[]=1&amp;baz[]=2">Hi<a>')
  end
end

class UtmParamsTest < Minitest::Test
  def test_default
    message = UtmParamsMailer.welcome.deliver_now
    refute_body "utm", message
  end

  def test_basic
    message = UtmParamsMailer.basic.deliver_now
    assert_body "utm_campaign=basic", message
    assert_body "utm_medium=email", message
    assert_body "utm_source=utm_params_mailer", message
  end

  def test_array_params
    message = UtmParamsMailer.array_params.deliver_now
    assert_body "baz%5B%5D=1&amp;baz%5B%5D=2", message
  end
end
