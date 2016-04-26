module Kaltura
  class Category < DelegateClass(Hashie::Mash)
    extend ClientResource

    def self.list(options={})
      _list = fetch('category', 'list', options).first
      return [] unless _list.totalCount.to_i > 0

      #NOTE: A single return value isn't an array, it's a hash so force it to be treated as an array of 1.
      items = _list.objects.item.respond_to?(:keys) ? [_list.objects.item] : _list.objects.item

      items.map do |item|
        item.total_count = _list.totalCount.to_i
        Kaltura::Category.new(item)
      end
    end

    private

    def self._ks_required?
      true
    end
  end
end
