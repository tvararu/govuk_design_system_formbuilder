module GOVUKDesignSystemFormBuilder
  module Elements
    class Hint < Base
      include Traits::Hint
      include Traits::Localisation

      def initialize(builder, object_name, attribute_name, text, value = nil, radio: false, checkbox: false)
        super(builder, object_name, attribute_name)

        @value          = value
        @hint_text      = hint_text(text)
        @radio_class    = radio_class(radio)
        @checkbox_class = checkbox_class(checkbox)
      end

      def html
        return nil if @hint_text.blank?

        tag.span(@hint_text, class: hint_classes, id: hint_id)
      end

    private

      def hint_text(supplied)
        [
          supplied.presence,
          localised_text(:hint)
        ].compact.first
      end

      def hint_classes
        %w(govuk-hint).push(@radio_class, @checkbox_class).compact
      end

      def radio_class(radio)
        radio ? 'govuk-radios__hint' : nil
      end

      def checkbox_class(checkbox)
        checkbox ? 'govuk-checkboxes__hint' : nil
      end
    end
  end
end
