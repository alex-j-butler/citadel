module AdminBar
  module Views
    class Git < View
      def git_revision
        if File.exists?(Rails.root.join(Rails.root, 'REVISION'))
          File.open(Rails.root.join(Rails.root, 'REVISION'), 'r') { |f| return f.gets.chomp }
        else
          `SHA1=$(git rev-parse HEAD 2> /dev/null); if [ $SHA1 ]; then echo $SHA1; else echo 'unknown'; fi`.chomp
        end
      end

      def git_revision_short
        git_revision.slice(0..6)
      end

      def results
        { rev: git_revision_short }
      end
    end
  end
end