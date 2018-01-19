module Leagues
  module Matches
    class BookedTimesController < ApplicationController
      include MatchesCommon
      include BookedTimeHelpers

      before_action only: [:suggest] do
        @match = League::Match.find(params[:match_id])
        @league = @match.league
      end
      before_action only: [:accept, :reject] do
        @time = League::Match::BookedTime.find(params[:id])
        @match  = @time.match
        @league = @match.league
      end
      before_action :require_user_can_suggest_times, only: [:suggest]
      before_action :require_user_can_accept_times, only: [:accept, :reject]

      def suggest
        League::Match::BookedTime.create(
          match: @match,
          user: current_user,
          time: construct_match_time(@match, time_params)
        )

        redirect_to match_path(@match)
      end

      def accept
        if @match.confirmed_time.nil?
          @time.update(status: 'accepted')
          @match.update(confirmed_time: @time)

          # schedule a delayed job for the server
        end

        redirect_to match_path(@match)
      end

      def reject
        @time.rejected! if @match.confirmed_time.nil?

        redirect_to match_path(@match)
      end

      private

      def time_params
        params[:day] = params[:day].to_i
        params[:hour] = params[:hour].to_i
        params[:minute] = params[:minute].to_i

        params.permit(:day, :hour, :minute).allow(day: 1..5, hour: 5..11, minute: 0..45)
      end

      def redirect_to_match
        redirect_to match_path(@match)
      end

      def require_user_can_suggest_times
        redirect_to_match unless user_can_suggest_times?
      end

      def require_user_can_accept_times
        redirect_to_match unless user_can_accept_times?(@time, @match)
      end
    end
  end
end
