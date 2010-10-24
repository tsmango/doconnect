class Util::Slug
  def self.generate(string, separator = '-')
    trim(string.gsub(/[^a-z0-9]+/i, separator).downcase)
  end
  
  def self.trim(string, separator = '_')
    # Trim trailing underscore from string
    while string[string.length - 1, string.length] == separator
      string = string.chop
    end
    
    # Trim leading underscore from string
    while string.length > 0 and string[0, 1] == separator
      string = string[1, string.length - 1]
    end
    
    string
  end
end