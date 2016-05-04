class GildedRose
  attr_accessor :specials

  def initialize(items)
    @items = items
    @specials = [
      {name: "Aged Brie", before_due: 1, after_due: 2},
      {name: "Conjured", before_due: -2, after_due: -4},
    ]
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
      if special?(item)
        item.quality += @specials.detect{|h| h[:name].include? item.name}[:after_due]
      elsif backstage_pass?(item)
        item.quality = 0
      else
        item.quality -= 2 
      end
    else 
      if special?(item)
        item.quality += @specials.detect{|h| h[:name].include? item.name}[:before_due]
      elsif backstage_pass?(item)
        item.quality += 1
        item.quality += 1 if item.sell_in < 11
        item.quality += 1 if item.sell_in < 6
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

  def special?(item)
    @specials.detect{|h| h[:name].include? item.name}.nil? ? false : true
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
