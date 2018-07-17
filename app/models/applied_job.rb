class AppliedJob < ApplicationRecord
  enum status: { applied_by_self: 0, submitted: 1, applied_by_invite: 2, declined: 3 }

	belongs_to :resume
	belongs_to :job

	validates :resume_id, uniqueness: { scope: :job_id }
end
