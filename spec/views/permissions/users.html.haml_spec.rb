require 'rails_helper'
require 'support/devise'
require 'support/factory_girl'

describe 'permissions/users' do
  let(:users) { create_list(:user, 4) }
  let(:team) { create(:team) }
  let(:user) { create(:user) }

  before do
    user.grant(:edit, :teams)

    view.lookup_context.prefixes = %w(application)
  end

  it 'shows all teams' do
    sign_in user
    assign(:users, User.paginate(page: 1))
    assign(:action, :edit)
    assign(:subject, :team)
    assign(:target, team.id)

    render
  end
end