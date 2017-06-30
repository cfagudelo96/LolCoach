module Speech
  def list_to_text(list, connector)
    text = ''
    list.each_with_index do |element, index|
      if index + 1 == list.length && list.length > 1
        text += " #{connector} "
      elsif index != 0
        text += ', '
      end
      text += element.to_s
    end
    text
  end
end
