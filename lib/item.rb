module Nanoc3
  class Item
    def title
      if self.attributes[:title]
        self.attributes[:title]
      else
        self.attributes[:filename].split('/').last.gsub(/_/, "\s").split('.').first
      end
    end
    
    def name
      self.attributes[:name] || title
    end
  end
end