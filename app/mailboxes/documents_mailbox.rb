class DocumentsMailbox < ApplicationMailbox
  def process
    document = Document.create(name: mail.subject, content: body)
    return if document.new_record?

    attachments.each do |attachment|
      document.files.attach(attachment)
    end
  end

  private

  def body
    if mail.multipart? && mail.html_part
      mail.html_part.body.decoded
    elsif mail.multipart? && mail.text_part
      mail.text_part.body.decoded
    else
      ''
    end
  end

  def attachments
    @attachments ||=
      mail.attachments.map do |attachment|
        ActiveStorage::Blob.create_after_upload!(
          io: StringIO.new(attachment.body.to_s),
          filename: attachment.filename,
          content_type: attachment.content_type
        )
      end
  end
end
