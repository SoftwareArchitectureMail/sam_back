require 'test_helper'

class SentMailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sent_mail = sent_mails(:one)
  end

  test "should get index" do
    get sent_mails_url, as: :json
    assert_response :success
  end

  test "should create sent_mail" do
    assert_difference('SentMail.count') do
      post sent_mails_url, params: { sent_mail: { attachment: @sent_mail.attachment, cc: @sent_mail.cc, confirmation: @sent_mail.confirmation, daft: @sent_mail.daft, distribution_list: @sent_mail.distribution_list, message_body: @sent_mail.message_body, recipient: @sent_mail.recipient, sender: @sent_mail.sender, sent_dateTime: @sent_mail.sent_dateTime, subject: @sent_mail.subject, urgent: @sent_mail.urgent } }, as: :json
    end

    assert_response 201
  end

  test "should show sent_mail" do
    get sent_mail_url(@sent_mail), as: :json
    assert_response :success
  end

  test "should update sent_mail" do
    patch sent_mail_url(@sent_mail), params: { sent_mail: { attachment: @sent_mail.attachment, cc: @sent_mail.cc, confirmation: @sent_mail.confirmation, daft: @sent_mail.daft, distribution_list: @sent_mail.distribution_list, message_body: @sent_mail.message_body, recipient: @sent_mail.recipient, sender: @sent_mail.sender, sent_dateTime: @sent_mail.sent_dateTime, subject: @sent_mail.subject, urgent: @sent_mail.urgent } }, as: :json
    assert_response 200
  end

  test "should destroy sent_mail" do
    assert_difference('SentMail.count', -1) do
      delete sent_mail_url(@sent_mail), as: :json
    end

    assert_response 204
  end
end
