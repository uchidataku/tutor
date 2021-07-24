# frozen_string_literal: true
# Ability
class Ability
  include CanCan::Ability

  # rubocop:disable Metrics/AbcSize
  def initialize(account)
    account ||= Account.new

    can :read, AcademicHistory
    can :manage, AcademicHistory, tutor_id: account&.tutor&.id
    can :read, Account
    can :manage, Account, id: account.id
    can :read, Examination
    can :manage, Examination, student_id: account&.student&.id
    can :manage, ExaminationItem, examination_id: account&.student&.examination_ids
    can %i[read create], Student
    can :manage, Student, account_id: account.id
    can :read, Subject
    can %i[read create], Tutor
    can :manage, Tutor, account_id: account.id
    can :read, WorkHistory
    can :manage, WorkHistory, tutor_id: account&.tutor&.id
  end
  # rubocop:enable all
end
