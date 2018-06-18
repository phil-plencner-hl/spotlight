module Blacklight
  module Rendering
    class Join < AbstractStep
      def render
        options = {:words_connector => "<br/>", :two_words_connector => "<br/>", :last_word_connector => "<br/> "}
        next_step(values.map { |x| html_escape(x) }.to_sentence(options).html_safe)
      end

      private

      def html_escape(*args)
        ERB::Util.html_escape(*args)
      end
    end
  end
end
