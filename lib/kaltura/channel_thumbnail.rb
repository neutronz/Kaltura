module Kaltura
  class ChannelThumbnail < DelegateClass(Hashie::Mash)
    extend ClientResource

    def self.list(options={})
      raise KalturaError, "Message: objectIdIn is missing" unless options[:filter].keys.include?(:objectIdIn)

      options[:filter].merge!({:metadataObjectTypeEqual => 2}) #"CATEGORY"
      options[:filter].merge!({:metadataProfileIdEqual => 4383381}) unless options[:filter].keys.include?(:metadataProfileIdEqual)

      binding.pry
      _list = fetch('metadata_metadata', 'list', options).first
      return [] unless _list.totalCount.to_i > 0

      #NOTE: A single return value isn't an array, it's a hash so force it to be treated as an array of 1.
      items = _list.objects.item.respond_to?(:keys) ? [_list.objects.item] : _list.objects.item

      items.map do |item|
        item.total_count = _list.totalCount.to_i
        Kaltura::ChannelThumbnail.new(extract_thumbnail(item))
      end
    end

    private

    def self.extract_thumbnail(item)
      #TODO
      item
    end

    def self._ks_required?
      true
    end
  end
end
