class GildedRose

  #def multiplier(item)
  #  quality_change[item] * 2
  #end

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      unless sulfuras?(item)
        update_sell_in(item)
        calculate_quality(item) if valid_quality?(item)
      end
    end
  end

  private 

  def update_sell_in(item)
    item.sell_in -= 1
  end

  def calculate_quality(item)
    if item.sell_in < 0 
      if aged_brie?(item)
        item.quality += 2
      elsif backstage_pass?(item)
        item.quality = 0
      elsif conjured?(item) 
        item.quality -= 4
      else
        item.quality -= 2 
      end
    else 
      if aged_brie?(item)
        item.quality += 1
      elsif backstage_pass?(item)
        item.quality += 1
        item.quality += 1 if item.sell_in < 11
        item.quality += 1 if item.sell_in < 6
      elsif conjured?(item)
        item.quality -= 2
      else
        item.quality -= 1 
      end
    end
  end

  # Validations
  def valid_quality?(item)
    item.quality > 0 && item.quality < 50
  end

  # Item Identifiers
  def sulfuras?(item)
    item.name.include?("Sulfuras")
  end

  def backstage_pass?(item)
    item.name.include?("Backstage passes")
  end

  def aged_brie?(item)
    item.name.include?("Aged Brie")
  end

  def conjured?(item)
    item.name.include?("Conjured")
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
