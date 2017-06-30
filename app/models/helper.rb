class Helper
  def self.split_string(string)
    list = string.split('-')
    list.shift
    list
  end
end