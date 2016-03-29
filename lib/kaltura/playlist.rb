module Kaltura
  class Playlist < DelegateClass(Hashie::Mash)
    extend ClientResource

    def self.get(id,version=nil)
      Kaltura::Playlist.new(fetch('playlist', 'get', {:id => id, :version => version}).first)
    end

    def self.execute(id, version=nil)
      result = fetch('playlist', 'execute', {:id => id, :version => version}).first
      result.fetch("item", []).map do |entry|
        Kaltura::MediaEntry.new(entry)
      end
    end

    def playlistType
      {
        "10" => :dynamic,
        "101" => :external,
        "3" => :static_list
      }[self["playlistType"].to_s]
    end

    private

    def self._ks_required?
      true
    end
  end
end
