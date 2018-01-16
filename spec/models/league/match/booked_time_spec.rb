require 'rails_helper'

describe League::Match::BookedTime do
  before(:all) { create(:booked_time) }

  it { should belong_to(:user) }
  it { should_not allow_value(nil).for(:user) }

  it { should belong_to(:match).class_name('League::Match') }
  it { should_not allow_value(nil).for(:match) }

end
