require 'rails_helper'

describe Leagues::Matches::BookedTimesController do
  let(:user) { create(:user) }
  let(:match) { create(:league_match) }

  describe 'POST suggest' do
    it 'succeeds for home team captain' do
      user.grant(:edit, match.home_team.team)
      sign_in user

      post :suggest, params: { match_id: match.id, day: 1, hour: 5, minute: 0 }

      booked_time = match.booked_times.first
      expect(booked_time.match_id).to eq(match.id)
      expect(response).to redirect_to(match_path(match))
    end

    it 'succeeds for away team captain' do
      user.grant(:edit, match.away_team.team)
      sign_in user

      post :suggest, params: { match_id: match.id, day: 1, hour: 5, minute: 0 }

      booked_time = match.booked_times.first
      expect(booked_time.match_id).to eq(match.id)
      expect(response).to redirect_to(match_path(match))
    end

    it 'succeeds for authorised admin' do
      user.grant(:edit, :leagues)
      sign_in user

      post :suggest, params: { match_id: match.id, day: 1, hour: 5, minute: 0 }

      booked_time = match.booked_times.first
      expect(booked_time.match_id).to eq(match.id)
      expect(response).to redirect_to(match_path(match))
    end

    it 'fails for unauthorised user' do
      sign_in user

      post :suggest, params: { match_id: match.id, day: 1, hour: 5, minute: 0 }

      booked_time = match.booked_times.first
      expect(booked_time).to eq(nil)
      expect(response).to redirect_to(match_path(match))
    end
  end

  describe 'PATCH accept' do
    let(:home_user) { create(:user) }
    let(:away_user) { create(:user) }
    let(:div) { create(:league_division) }
    let(:home_roster) {
      create(:league_roster,
        division: div,
        players: [
          create(:league_roster_player, user: home_user)
        ]
      )
    }
    let(:away_roster) {
      create(:league_roster,
        division: div,
        players: [
          create(:league_roster_player, user: away_user)
        ]
      )
    }
    let(:match) { create(:league_match, home_team: home_roster, away_team: away_roster) }
    let(:time_home_team) { create(:booked_time_home_team, match: match) }
    let(:time_away_team) { create(:booked_time_away_team, match: match) }

    context 'when home team suggested time' do
      it 'succeeds for away team captain' do
        away_user.grant(:edit, match.away_team.team)
        sign_in away_user

        patch :accept, params: { match_id: match.id, id: time_home_team.id }

        expect(match.reload.confirmed_time).to eq(time_home_team)
        expect(time_home_team.reload.status).to eq('accepted')
        expect(response).to redirect_to(match_path(match))
      end

      it 'fails for home team captain' do
        home_user.grant(:edit, match.home_team.team)
        sign_in home_user

        patch :accept, params: { match_id: match.id, id: time_home_team.id }

        expect(match.reload.confirmed_time).to eq(nil)
        expect(time_home_team.reload.status).to eq('pending')
        expect(response).to redirect_to(match_path(match))
      end

      context 'when user is authorised admin' do
        it 'succeeds' do
          user.grant(:edit, :leagues)
          sign_in user

          patch :accept, params: { match_id: match.id, id: time_home_team.id }

          expect(match.reload.confirmed_time).to eq(time_home_team)
          expect(time_home_team.reload.status).to eq('accepted')
          expect(response).to redirect_to(match_path(match))
        end

        it 'succeeds for home team captain' do
          home_user.grant(:edit, :leagues)
          home_user.grant(:edit, match.home_team.team)
          sign_in home_user

          patch :accept, params: { match_id: match.id, id: time_home_team.id }

          expect(match.reload.confirmed_time).to eq(time_home_team)
          expect(time_home_team.reload.status).to eq('accepted')
          expect(response).to redirect_to(match_path(match))
        end

        it 'succeeds for away team captain' do
          away_user.grant(:edit, :leagues)
          away_user.grant(:edit, match.away_team.team)
          sign_in away_user

          patch :accept, params: { match_id: match.id, id: time_home_team.id }

          expect(match.reload.confirmed_time).to eq(time_home_team)
          expect(time_home_team.reload.status).to eq('accepted')
          expect(response).to redirect_to(match_path(match))
        end
      end
    end

    context 'when away team suggested time' do
      it 'succeeds for home team captain' do
        home_user.grant(:edit, match.home_team.team)
        sign_in home_user

        patch :accept, params: { match_id: match.id, id: time_away_team.id }

        expect(match.reload.confirmed_time).to eq(time_away_team)
        expect(time_away_team.reload.status).to eq('accepted')
        expect(response).to redirect_to(match_path(match))
      end

      it 'fails for away team captain' do
        away_user.grant(:edit, match.away_team.team)
        sign_in away_user

        patch :accept, params: { match_id: match.id, id: time_away_team.id }

        expect(match.reload.confirmed_time).to eq(nil)
        expect(time_away_team.reload.status).to eq('pending')
        expect(response).to redirect_to(match_path(match))
      end

      context 'when user is authorised admin' do
        it 'succeeds' do
          user.grant(:edit, :leagues)
          sign_in user

          patch :accept, params: { match_id: match.id, id: time_away_team.id }

          expect(match.reload.confirmed_time).to eq(time_away_team)
          expect(time_away_team.reload.status).to eq('accepted')
          expect(response).to redirect_to(match_path(match))
        end

        it 'succeeds for home team captain' do
          home_user.grant(:edit, :leagues)
          home_user.grant(:edit, match.home_team.team)
          sign_in home_user

          patch :accept, params: { match_id: match.id, id: time_away_team.id }

          expect(match.reload.confirmed_time).to eq(time_away_team)
          expect(time_away_team.reload.status).to eq('accepted')
          expect(response).to redirect_to(match_path(match))
        end

        it 'succeeds for away team captain' do
          away_user.grant(:edit, :leagues)
          away_user.grant(:edit, match.away_team.team)
          sign_in away_user

          patch :accept, params: { match_id: match.id, id: time_away_team.id }

          expect(match.reload.confirmed_time).to eq(time_away_team)
          expect(time_away_team.reload.status).to eq('accepted')
          expect(response).to redirect_to(match_path(match))
        end
      end
    end
  end

  describe 'PATCH reject' do
    let(:home_user) { create(:user) }
    let(:away_user) { create(:user) }
    let(:div) { create(:league_division) }
    let(:home_roster) {
      create(:league_roster,
        division: div,
        players: [
          create(:league_roster_player, user: home_user)
        ]
      )
    }
    let(:away_roster) {
      create(:league_roster,
        division: div,
        players: [
          create(:league_roster_player, user: away_user)
        ]
      )
    }
    let(:match) { create(:league_match, home_team: home_roster, away_team: away_roster) }
    let(:time_home_team) { create(:booked_time_home_team, match: match) }
    let(:time_away_team) { create(:booked_time_away_team, match: match) }

    context 'when home team suggested time' do
      it 'succeeds for away team captain' do
        away_user.grant(:edit, match.away_team.team)
        sign_in away_user

        patch :reject, params: { match_id: match.id, id: time_home_team.id }

        expect(match.reload.confirmed_time).to eq(nil)
        expect(time_home_team.reload.status).to eq('rejected')
        expect(response).to redirect_to(match_path(match))
      end

      it 'fails for home team captain' do
        home_user.grant(:edit, match.home_team.team)
        sign_in home_user

        patch :reject, params: { match_id: match.id, id: time_home_team.id }

        expect(match.reload.confirmed_time).to eq(nil)
        expect(time_home_team.reload.status).to eq('pending')
        expect(response).to redirect_to(match_path(match))
      end

      context 'when user is authorised admin' do
        it 'succeeds' do
          user.grant(:edit, :leagues)
          sign_in user

          patch :reject, params: { match_id: match.id, id: time_home_team.id }

          expect(match.reload.confirmed_time).to eq(nil)
          expect(time_home_team.reload.status).to eq('rejected')
          expect(response).to redirect_to(match_path(match))
        end

        it 'succeeds for home team captain' do
          home_user.grant(:edit, :leagues)
          home_user.grant(:edit, match.home_team.team)
          sign_in home_user

          patch :reject, params: { match_id: match.id, id: time_home_team.id }

          expect(match.reload.confirmed_time).to eq(nil)
          expect(time_home_team.reload.status).to eq('rejected')
          expect(response).to redirect_to(match_path(match))
        end

        it 'succeeds for away team captain' do
          away_user.grant(:edit, :leagues)
          away_user.grant(:edit, match.away_team.team)
          sign_in away_user

          patch :reject, params: { match_id: match.id, id: time_home_team.id }

          expect(match.reload.confirmed_time).to eq(nil)
          expect(time_home_team.reload.status).to eq('rejected')
          expect(response).to redirect_to(match_path(match))
        end
      end
    end

    context 'when away team suggested time' do
      it 'succeeds for home team captain' do
        home_user.grant(:edit, match.home_team.team)
        sign_in home_user

        patch :reject, params: { match_id: match.id, id: time_away_team.id }

        expect(match.reload.confirmed_time).to eq(nil)
        expect(time_away_team.reload.status).to eq('rejected')
        expect(response).to redirect_to(match_path(match))
      end

      it 'fails for away team captain' do
        away_user.grant(:edit, match.away_team.team)
        sign_in away_user

        patch :reject, params: { match_id: match.id, id: time_away_team.id }

        expect(match.reload.confirmed_time).to eq(nil)
        expect(time_away_team.reload.status).to eq('pending')
        expect(response).to redirect_to(match_path(match))
      end

      context 'when user is authorised admin' do
        it 'succeeds' do
          user.grant(:edit, :leagues)
          sign_in user

          patch :reject, params: { match_id: match.id, id: time_away_team.id }

          expect(match.reload.confirmed_time).to eq(nil)
          expect(time_away_team.reload.status).to eq('rejected')
          expect(response).to redirect_to(match_path(match))
        end

        it 'succeeds for home team captain' do
          home_user.grant(:edit, :leagues)
          home_user.grant(:edit, match.home_team.team)
          sign_in home_user

          patch :reject, params: { match_id: match.id, id: time_away_team.id }

          expect(match.reload.confirmed_time).to eq(nil)
          expect(time_away_team.reload.status).to eq('rejected')
          expect(response).to redirect_to(match_path(match))
        end

        it 'succeeds for away team captain' do
          away_user.grant(:edit, :leagues)
          away_user.grant(:edit, match.away_team.team)
          sign_in away_user

          patch :reject, params: { match_id: match.id, id: time_away_team.id }

          expect(match.reload.confirmed_time).to eq(nil)
          expect(time_away_team.reload.status).to eq('rejected')
          expect(response).to redirect_to(match_path(match))
        end
      end
    end
  end
end
