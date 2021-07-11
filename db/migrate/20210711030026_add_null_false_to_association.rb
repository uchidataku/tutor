class AddNullFalseToAssociation < ActiveRecord::Migration[6.1]
  def change
    change_column_null :academic_histories, :tutor_id, false
    change_column_null :jtis, :account_id, false
    change_column_null :students, :account_id, false
    change_column_null :tutors, :account_id, false
  end
end
