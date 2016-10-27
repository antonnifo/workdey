class Service < ActiveRecord::Base
  belongs_to :tasker, class_name: "User"
  belongs_to :artisan, class_name: "User"
  belongs_to :skillset
  has_many :service_assignments
  has_many :notifications, as: :notifiable

  validates :title,
            presence: true

  validates :description,
            presence: true

  validates :skillset_id,
            presence: true

  validates :start_date,
            presence: true

  validates :end_date,
            presence: true

  validates :duration,
            presence: true

  validates :status,
            presence: true

  validate :end_date_must_be_greater_than_start_date

  enum status: [:unassigned, :assigned, :accepted]

  def self.pending_requests(current_user)
    where("tasker_id = ? AND status = ?", current_user, 0)
  end

  def expired?
    Time.now > created_at + 5.hours
  end

  private

  def end_date_must_be_greater_than_start_date
    if start_date && end_date
      check_start_and_end_dates
    else
      errors[:date] = "Service date cannot be nil"
    end
  end

  def check_start_and_end_dates
    same_day = start_date == end_date
    unless (end_date > start_date && end_date > Time.now) || same_day
      errors[:date] = "End date cannot be in the past"
    end
  end
end
