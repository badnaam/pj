Paperclip.interpolates :username do |attachment, style|
    attachment.instance.username
end

Paperclip.interpolates :imageible_name do |attachment, style|
    attachment.instance.imageible.imageible_name
end