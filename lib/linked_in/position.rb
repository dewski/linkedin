module LinkedIn
  class Position < LinkedIn::Base

    def positions
      @positions ||= @doc.children.inject([]) do |list, position|
        list << Resource.new(position) unless position.blank?
        list
      end
    end

    class Resource

      def initialize(position)
        @position = position
      end

      %w[id title summary is_current].each do |f|
        define_method(f.to_sym) do
          @position.xpath("./#{f.gsub(/_/,'-')}").text
        end
      end

      def start_month
        @position.xpath('./start-date/month').text.to_i
      end

      def start_year
        @position.xpath('./start-date/year').text.to_i
      end

      def start_date
        if !start_year.zero? && !start_month.zero? # Has start month and year
          DateTime.new(start_year, start_month)
        elsif !start_year.zero? && start_month.zero? # Only has start year
          DateTime.new(start_year)
        end
      end

      def end_month
        @position.xpath('./end-date/month').text.to_i
      end

      def end_year
        @position.xpath('./end-date/year').text.to_i
      end

      def end_date
        if !end_year.zero? && !end_month.zero? # Has end month and year
          DateTime.new(end_year, end_month)
        elsif !end_year.zero? && end_month.zero? # Only has end year
          DateTime.new(end_year)
        end
      end

      def company
        @company ||= Company.new(@position.xpath('./company'))
      end

    end # resource

  end # class
end # module
