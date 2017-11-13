require 'test_helper'

class ReceivedMailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @received_mail = received_mails(:one)
  end

  test "should get index" do
    get received_mails_url, as: :json
    assert_response :success
  end

  test "should create received_mail" do
    assert_difference('ReceivedMail.count') do
      post received_mails_url, params: { received_mail: { Attachments: @received_mail.Attachments, Cc: @received_mail.Cc, Created_dateTime: @received_mail.Created_dateTime, Distribution_list: @received_mail.Distribution_list, Message_body: @received_mail.Message_body, Read: @received_mail.Read, Recipient: @received_mail.Recipient, Sender: @received_mail.Sender, Sent_dateTime: @received_mail.Sent_dateTime, Subject: @received_mail.Subject, Urgent: @received_mail.Urgent } }, as: :json
    end

    assert_response 201
  end

  test "should show received_mail" do
    get received_mail_url(@received_mail), as: :json
    assert_response :success
  end

  test "should update received_mail" do
    patch received_mail_url(@received_mail), params: { received_mail: { Attachments: @received_mail.Attachments, Cc: @received_mail.Cc, Created_dateTime: @received_mail.Created_dateTime, Distribution_list: @received_mail.Distribution_list, Message_body: @received_mail.Message_body, Read: @received_mail.Read, Recipient: @received_mail.Recipient, Sender: @received_mail.Sender, Sent_dateTime: @received_mail.Sent_dateTime, Subject: @received_mail.Subject, Urgent: @received_mail.Urgent } }, as: :json
    assert_response 200
  end

  test "should destroy received_mail" do
    assert_difference('ReceivedMail.count', -1) do
      delete received_mail_url(@received_mail), as: :json
    end

    assert_response 204
  end
end
