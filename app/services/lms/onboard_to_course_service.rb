
module Lms
  class OnboardToCourseService
    def initialize(course, name, email)
      @course = course
      @name = name
      @email = email
    end

    def execute
      return if cohort.blank?
      Cohort.transaction { create_new_student }
    end

    private

    def create_new_student
      # Find or create a user with the given email.
      user = school.pupilfirst_users.where(email: @email).first_or_create!(name: @name)

      # If a user was already present, don't override values of name, title, organisation or affiliation.
      user.update!(
        name: user.name.presence || @name,
        title: user.title.presence || "Student",
      )
      # check if the user is already a student in the cohort.
      student = user.students.find_by(cohort_id: cohort.id)
      # return the student if the user is already a student in the cohort.
      return student if student.present?
      # Create a new student in the cohort.
      student =  user.students.create!(cohort_id: cohort.id)
      student
    end



    def school
      @school ||= @course.school
    end

    def cohort
      @cohort ||= @course.beckn_cohort
    end
  end
end
