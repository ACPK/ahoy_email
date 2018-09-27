require_relative "test_helper"

class MessageMailer < ApplicationMailer
  track message: false, only: [:other]
  track message: true, only: [:other2]

  after_action :prevent_delivery

  def welcome
    mail
  end

  def other
    mail
  end

  def other2
    mail
  end

  private

  def prevent_delivery
    mail.perform_deliveries = false if params && params[:deliver] == false
  end
end

class MessageTest < Minitest::Test
  def test_default
    MessageMailer.welcome.deliver_now
    assert ahoy_message
  end

  def test_false
    MessageMailer.other.deliver_now
    assert_nil ahoy_message
  end

  def test_prevent_delivery
    MessageMailer.with(deliver: false).welcome.deliver_now
    assert_nil ahoy_message
  end

  def test_default_false
    with_default(message: false) do
      MessageMailer.welcome.deliver_now
      assert_nil ahoy_message
    end
  end

  def test_default_false_track
    with_default(message: false) do
      MessageMailer.other2.deliver_now
      assert ahoy_message
    end
  end
end
