class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      unless sulfuras?(item)
        calculate_quality(item) if valid_quality?(item)
        update_sell_in(item)
      end
    end
  end

  private 

  def calculate_quality(item)
    case item_name(item)
      when /aged brie/ then quality_change(item, 1) 
      when /backstage passes/ then pass_quality_change(item) 
      when /conjured/ then quality_change(item, -2)
      when  // then quality_change(item, -1) 
    end
  end

  def quality_change(item, amount)
    item.quality += item.sell_in <= 0 ? amount * 2 : amount
  end

  def pass_quality_change(item)
    if item.sell_in <= 0
      item.quality = 0
    else
      item.quality += (item.sell_in < 6 ? 3 : item.sell_in.between?(6,11) ? 2 : 1)
    end
  end

  def update_sell_in(item)
    item.sell_in -= 1
  end

  def valid_quality?(item)
    item.quality > 0 && item.quality < 50
  end

  def item_name(item)
    item.name.downcase
  end

  def sulfuras?(item)
    item_name(item).include?("sulfuras")
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
