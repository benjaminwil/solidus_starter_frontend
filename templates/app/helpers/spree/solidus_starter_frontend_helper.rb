# frozen_string_literal: true

module Spree
  module SolidusStarterFrontendHelper
    def breadcrumbs(taxon)
      return '' if current_page?('/') || taxon.nil?

      base_class = 'breadcrumbs'
      breadcrumb_class = "#{base_class}__content"
      separator = '&nbsp;&raquo;&nbsp;'

      crumbs = [[t('spree.home'), spree.root_path]]

      crumbs << [t('spree.products'), products_path]
      if taxon
        crumbs += taxon.ancestors.collect { |ancestor| [ancestor.name, spree.nested_taxons_path(ancestor.permalink)] }
        crumbs << [taxon.name, spree.nested_taxons_path(taxon.permalink)]
      end

      separator = raw(separator)

      items = crumbs.each_with_index.collect do |crumb, index|
        content_tag(:li, itemprop: 'itemListElement', itemscope: '', itemtype: 'https://schema.org/ListItem') do
          link_to(crumb.last, itemprop: 'item') do
            content_tag(:span, crumb.first, itemprop: 'name') + tag('meta', { itemprop: 'position', content: (index + 1).to_s }, false, false)
          end + (crumb == crumbs.last ? '' : separator)
        end
      end

      content_tag(
        :div,
        content_tag(
          :nav,
          content_tag(
            :ol,
            raw(items.map(&:mb_chars).join),
            itemscope: '',
            itemtype: 'https://schema.org/BreadcrumbList'),
          class: breadcrumb_class
        ),
        class: base_class
      )
    end

    def generate_address_id(form, input_name)
      "#{form.object_name.gsub(/[\[\]]/, '[' => '_', ']' => '_')}#{input_name}"
    end

    def generate_selected_shipping_rate_id(form, input_name, rate)
      "#{form.object_name.gsub(/[\[\]]/, '[' => '_', ']' => '_')}#{input_name}_#{rate.id}"
    end
  end
end
