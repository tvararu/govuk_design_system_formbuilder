module GOVUKDesignSystemFormBuilder
  module Containers
    class Fieldset < Base
      using PrefixableArray

      include Traits::Localisation

      LEGEND_SIZES = %w(xl l m s).freeze

      def initialize(builder, object_name = nil, attribute_name = nil, legend: {}, described_by: nil, &block)
        super(builder, object_name, attribute_name, &block)

        @described_by   = described_by(described_by)
        @attribute_name = attribute_name

        case legend
        when Proc
          @legend = legend.call
        when Hash
          @legend_options = legend_defaults.merge(legend)
        else
          fail(ArgumentError, %(legend must be a Proc or Hash))
        end
      end

      def html
        content_tag('fieldset', class: fieldset_classes, aria: { describedby: @described_by }) do
          safe_join([legend_content, (@block_content || yield)])
        end
      end

    private

      def legend_content
        @legend || build_legend
      end

      def build_legend
        if legend_text.present?
          content_tag('legend', class: legend_classes) do
            tag.send(@legend_options.dig(:tag), legend_text, class: legend_heading_classes)
          end
        end
      end

      def legend_text
        [@legend_options.dig(:text), localised_text(:legend)].compact.first
      end

      def fieldset_classes
        %w(fieldset).prefix(brand)
      end

      def legend_classes
        size = @legend_options.dig(:size)
        fail "invalid size '#{size}', must be #{LEGEND_SIZES.join(', ')}" unless size.in?(LEGEND_SIZES)

        [%(fieldset__legend), %(fieldset__legend--#{size})].prefix(brand).tap do |classes|
          classes.push(%(#{brand}-visually-hidden)) if @legend_options.dig(:hidden)
        end
      end

      def legend_heading_classes
        %w(fieldset__heading).prefix(brand)
      end

      def legend_defaults
        {
          hidden: false,
          text: nil,
          tag:  config.default_legend_tag,
          size: config.default_legend_size
        }
      end
    end
  end
end
