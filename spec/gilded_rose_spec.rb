require 'spec_helper'
 
describe GildedRose do
  let(:quality) { 10 }
  let(:sell_in) { 10 }
  let(:item) { Item.new(name, sell_in, quality) }

  describe "#update_quality" do

    context "Normal Item" do
      let(:name) { "Random Normal Item +15" }

      it "degrades quality when sell_in gets nearer" do
        GildedRose.new([item]).update_quality

        expect(item.sell_in).to eq 9
        expect(item.quality).to eq 9
      end

      it "degrades quality twice as fast when sell_in had passed" do
        item.sell_in = -1

        GildedRose.new([item]).update_quality

        expect(item.sell_in).to eq -2
        expect(item.quality).to eq 8
      end
    end

    context "Sulfuras" do
      let(:name) { "Sulfuras, Hand of Ragnaros" }

      it "does not degrade quality and sell_in" do
        GildedRose.new([item]).update_quality

        expect(item.sell_in).to eq 10
        expect(item.quality).to eq 10
      end
    end

    context "Aged Brie" do
      let(:name) { "Aged Brie" }

      it "increases quality when sell_in is lower" do
        GildedRose.new([item]).update_quality

        expect(item.sell_in).to eq 9
        expect(item.quality).to eq 11
      end

      it "increases quality more when sell_in has passed" do
        item.sell_in = -1

        GildedRose.new([item]).update_quality

        expect(item.sell_in).to eq -2
        expect(item.quality).to eq 12
      end
    end

    context "Backstage Passes" do
      let(:name) { "Backstage passes to a TAFKAL80ETC concert" }

      it "increases quality when sell_in is lower" do
        item.sell_in = 15

        GildedRose.new([item]).update_quality

        expect(item.sell_in).to eq 14
        expect(item.quality).to eq 11
      end

      it "increases quality by 2 when 10 days or less sell_in is left" do
        item.sell_in = 10

        GildedRose.new([item]).update_quality

        expect(item.sell_in).to eq 9
        expect(item.quality).to eq 12
      end

      it "increases quality by 3 when 5 days or less sell_in is left" do
        item.sell_in = 5

        GildedRose.new([item]).update_quality

        expect(item.sell_in).to eq 4
        expect(item.quality).to eq 13
      end

      it "drops quality to 0 when sell_in has passed" do
        item.sell_in = 0

        GildedRose.new([item]).update_quality

        expect(item.sell_in).to eq -1
        expect(item.quality).to eq 0
      end
    end

    context "Conjured" do
      let(:name) { "Conjured" }

      it "degrades quality twice as fast as normal items when sell_in gets nearer" do
        GildedRose.new([item]).update_quality

        expect(item.sell_in).to eq 9
        expect(item.quality).to eq 8
      end

      it "degrades quality twice as fast as normal items when sell_in has passed" do
        item.sell_in = -1
        GildedRose.new([item]).update_quality

        expect(item.sell_in).to eq -2
        expect(item.quality).to eq 6
      end
    end

    context "Multiple Items" do
      let(:items) { 
                    [ Item.new("Sulfuras, Hand of Ragnaros", 10, 50),
                      Item.new("Phoenix Down", 10, 20),
                      Item.new("Aged Brie", 0, 12) ] 
                  }

      it "accepts multiple items" do
        GildedRose.new(items).update_quality

        # Sulfuras
        expect(items[0].sell_in).to eq 10
        expect(items[0].quality).to eq 50
        # Phoenix Down
        expect(items[1].sell_in).to eq 9
        expect(items[1].quality).to eq 19
        # Aged Brie 
        expect(items[2].sell_in).to eq -1
        expect(items[2].quality).to eq 14
      end
    end

    context "Quality Value" do
      let(:name) { "Aged Brie" }

      it "does not go beyond 50" do
        item.quality = 50

        GildedRose.new([item]).update_quality

        expect(item.sell_in).to eq 9
        expect(item.quality).to eq 50
      end

      it "does not go lower than 0" do
        item.name = "Elixir"
        item.quality = 0

        GildedRose.new([item]).update_quality

        expect(item.sell_in).to eq 9
        expect(item.quality).to eq 0
      end
    end

  end
end