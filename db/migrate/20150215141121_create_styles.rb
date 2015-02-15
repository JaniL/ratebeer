class CreateStyles < ActiveRecord::Migration
  def change
    create_table :styles do |t|
      t.string :name

      t.timestamps null: false
    end

    #Beer.all.each do |beer|
    #  Style.create name: beer.style unless Style.where(name: beer.style).size == 1
    #end

    change_table :beers do |t|
      t.rename :style, :old_style
    end
  end
end
