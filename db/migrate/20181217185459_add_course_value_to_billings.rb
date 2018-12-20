class AddCourseValueToBillings < ActiveRecord::Migration[5.2]
  def change
    add_column :billings, :course_value, :decimal
  end
end
