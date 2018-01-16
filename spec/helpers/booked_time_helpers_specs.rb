require 'rails_helper'

describe Leagues::Matches::BookedTimeHelpers do

  describe 'construct_match_time' do

    it 'outputs the correct date' do
      expected_time = Time.new 2018, 1, 16, 19, 45

      match = League::Match.new(week_beginning: Date.new(2018, 1, 15))
      time_params = {day: 2, hour: 7, minute: 45}
      match_time = construct_match_time(match, time_params)

      expect(match_time).to eq(expected_time)
    end

    it 'handles out of bounds days' do
      match = League::Match.new(week_beginning: Date.new(2018, 1, 15))
      time_params = {day: 16, hour: 7, minute: 45}
      match_time = construct_match_time(match, time_params)

      expect(match_time).to eq(Time.new 2018, 1, 21, 19, 45)
    end

    it 'handles out of bounds hours' do
      match = League::Match.new(week_beginning: Date.new(2018, 1, 15))
      time_params = {day: 4, hour: 21, minute: 45}
      match_time = construct_match_time(match, time_params)

      expect(match_time).to eq(Time.new 2018, 1, 18, 23, 45)
    end

    it 'handles out of bounds minutes' do
      match = League::Match.new(week_beginning: Date.new(2018, 1, 15))
      time_params = {day: 4, hour: 7, minute: 162}
      match_time = construct_match_time(match, time_params)

      expect(match_time).to eq(Time.new 2018, 1, 18, 19, 59)
    end

  end

end
