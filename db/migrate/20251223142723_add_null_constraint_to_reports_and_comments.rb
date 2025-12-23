class AddNullConstraintToReportsAndComments < ActiveRecord::Migration[8.0]
   def change
     change_column_null :reports, :title, false
     change_column_null :reports, :body, false
     change_column_null :comments, :body, false
   end
end
