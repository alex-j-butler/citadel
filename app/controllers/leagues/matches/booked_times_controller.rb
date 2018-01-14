module Leagues
  module Matches
    class BookedTimesController < ApplicationController
      include MatchesCommon
      include BookedTimeHelpers

      before_action only: [:suggest] do
        @match = League::Match.find(params[:match_id])
      end
      before_action only: [:accept, :reject] do
        @time = League::Match::BookedTime.find(params[:id])
        @match  = @time.match
        @league = @match.league
      end
      before_action :require_user_can_accept_times

      def suggest
        League::Match::BookedTime.create(match: @match, user: current_user, time: construct_match_time(@match, time_params))

        redirect_to match_path(@match)
      end

      def accept
        if @match.confirmed_time.nil? then
          @time.accepted!
          @match.confirmed_time = @time
          @match.save

          # schedule a delayed job for the server
        end

        redirect_to match_path(@match)
      end

      def reject
        if @match.confirmed_time.nil? then
          @time.rejected!
        end

        redirect_to match_path(@match)
      end

      private

      def time_params
        params[:day] = params[:day].to_i
        params[:hour] = params[:hour].to_i
        params[:minute] = params[:minute].to_i

        p = params.permit(:day, :hour, :minute).allow(day: 1..5, hour: 5..11, minute: 0..45)
        puts 1..5
        puts p

        p
      end

      def redirect_to_match
        redirect_to match_path(@match)
      end

      def require_user_can_accept_times
        redirect_to_match unless user_can_accept_times?(@time, @match)
      end
    end
  end
end
