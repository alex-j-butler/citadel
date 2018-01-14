module Leagues
  module Matches
    module BookedTimeHelpers

      def construct_match_time(match, time_params)
        match_time = match.week_beginning
        match_time ||= Date.today.beginning_of_week
        match_time = match_time.to_time

        match_time = match_time.change(
          day: match_time.day + (time_params[:day] - 1), # just don't ask
          hour: time_params[:hour] + 12, # convert to PM
          min: time_params[:minute]
        )

        match_time
      end

    end
  end
end