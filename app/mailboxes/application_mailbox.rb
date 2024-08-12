class ApplicationMailbox < ActionMailbox::Base
  routing /^documents/i => :documents

  def from
    @from ||= mail.from.first
  end
end
