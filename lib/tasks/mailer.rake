desc "Send email"

task :send_act_in_email => :environment do
    @user.deliver_activation_instructions!
end