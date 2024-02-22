class CreateModerationModels < ActiveRecord::Migration[7.1]
  def change
    create_table :moderation_models do |t|
      t.string :content
      t.string :language
      t.boolean :is_accepted

      t.timestamps
    end
  end
end