require "rails_helper"

describe "public_activity/webhook/_create" do
  # Create a registry and the admin user. This way we have a namespace for the
  # webhooks that might be created by the different tests.
  let!(:registry) { create(:registry) }
  let!(:user)     { create(:admin) }

  before :each do
    user.create_personal_namespace!
    @webhook  = create(:webhook, namespace: user.namespace)
    @activity = @webhook.create_activity :created, owner: user
  end

  it "renders the activity properly when the user exists" do
    render "public_activity/webhook/create", activity: @activity

    text = assert_select(".description h6").text
    expect(text).to eq("#{user.display_username} created webhook " \
                       "#{@webhook.host} under the #{user.namespace.name} namespace")
  end

  it "renders the activity even if the webhook got removed" do
    @webhook.destroy
    @activity.reload

    render "public_activity/webhook/create", activity: @activity

    text = assert_select(".description h6").text
    expect(text).to eq("#{user.display_username} created webhook " \
                       "#{@webhook.host} under the #{user.namespace.name} namespace")
  end
end
