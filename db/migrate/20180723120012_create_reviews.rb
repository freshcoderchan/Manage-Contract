class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.integer :balance
      t.integer :benefits
      t.integer :advancement
      t.integer :management
      t.integer :culture
      t.decimal :average
      t.integer :question1
      t.integer :question2
      t.integer :question3
      t.integer :question4
      t.integer :question5
      t.text :description

      t.timestamps
    end
  end
end