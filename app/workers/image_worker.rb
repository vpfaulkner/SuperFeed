class ImageWorker
  include Sidekiq::Worker

  def preform(id)

  end

end


# def perform(id)
#     ringtone = Ringtone.find(id)
#     source = ringtone.source
#     outfile = Paperclip::Tempfile.new(['ringtone', '.mp3'])
#     Paperclip.run("ffmpeg", "-i #{source.path} -y -t 30 -acodec copy #{outfile.path}" )
#     ringtone.ringtone = outfile
#     ringtone.processing = false
#     ringtone.save
#     outfile.close
#   end
#
#   def perform(snippet_id)
#     snippet = Snippet.find(snippet_id)
#     uri = URI.parse("http://pygments.appspot.com/")
#     request = Net::HTTP.post_form(uri, lang: snippet.language, code: snippet.plain_code)
#     snippet.update_attribute(:highlighted_code, request.body)
#   end
