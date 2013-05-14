module LinkedIn
  class Company < LinkedIn::Base

    %w[id name industry type size].each do |f|
      define_method(f.to_sym) do
        @doc.xpath("./#{f.gsub(/_/,'-')}").text
      end
    end

  end
end
