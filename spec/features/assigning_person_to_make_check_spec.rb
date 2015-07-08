require "rails_helper"

feature "assign user to perform check" do
  let(:project) { create(:project) }
  let(:reminder) { create(:reminder) }
  let!(:project_check) do
    create(:project_check,
           project: project,
           reminder: reminder,
          )
  end
  let(:user) { create(:user, uid: "12331", provider: "google_oauth2") }
  let(:second_user) { create(:user, name: "John Smith") }
  let(:page) { Reminders::ReminderPage.new }

  before do
    log_in(user)
  end

  scenario "there is no user assigned yet" do
    page.load reminder_id: reminder.id

    expect(page.first_project)
      .not_to have_text user.name
    expect(page.first_project)
      .to have_button("Pick random")

    page.first_project.pick_random_button.click

    expect(page.first_project.assigned_reviewer)
      .to have_text user.name
    expect(page.first_project)
      .not_to have_button("Pick random")
  end

  scenario "someone has already checked project" do
    visit reminder_path(reminder)
    expect(page.first_project)
      .not_to have_text user.name
    expect(page.first_project)
      .to have_button("Pick random")

    page.first_project.check_button.click

    expect(page.first_project.last_checker)
      .to have_text user.name
    expect(page.first_project)
      .not_to have_text second_user.name

    page.first_project.pick_random_button.click

    expect(page.first_project.assigned_reviewer)
      .to have_text "Assigned: #{second_user.name}"
    expect(page.first_project)
      .not_to have_button("Pick random")
  end
end