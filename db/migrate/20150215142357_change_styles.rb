class ChangeStyles < ActiveRecord::Migration
  def change

    add_column :beers, :style_id, :integer

    Beer.all.each do |beer|

      tyyli = Style.where(name: beer.old_style)

      if tyyli.size == 0
        tyyli = Style.create name: beer.old_style
      else
        tyyli = tyyli[0]
      end

      beer.style = tyyli
      beer.save()

    end
  end
end
