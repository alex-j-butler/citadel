module AdminBar
  module Views
    class DelayedJob < View
      def title
        'delayed job'
      end

      def results
        { queued: queued, failed: failed }
      end

      def queued
        Delayed::Job.count
      end

      def failed
        Delayed::Job.where.not(failed_at: nil).count
      end
    end
  end
end
