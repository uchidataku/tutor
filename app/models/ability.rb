# frozen_string_literal: true
# Ability
class Ability
  include CanCan::Ability

  def initialize(account)
    account ||= Account.new

    can :read, AcademicHistory
    can :manage, AcademicHistory, tutor_id: account&.tutor&.id
    can :read, Account
    can :manage, Account, id: account.id
    can %i[read create], Student
    can :manage, Student, account_id: account.id
    can %i[read create], Tutor
    can :manage, Tutor, account_id: account.id
    can :read, WorkHistory
    can :manage, WorkHistory, tutor_id: account&.tutor&.id
  end
end
