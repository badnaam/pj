class Notifier < ActionMailer::Base

    ActionMailer::Base.smtp_settings = {
        :address => "smtp.gmail.com",
        :port => 587,
        :domain => "domain.com",
        :user_name => "pjointadm@gmail.com",
        :password => "badnaam1",
        :authentication => :plain,
        :enable_starttls_auto => true
    }

    def hello_world(email)
        recipients email
        from "pjointadm@gmail.com"
        subject "Hello"
        sent_on Time.now
        body "Here is the body"
    end

    
    def password_reset_instructions(user)
        subject       "PointJoint Password Reset Instructions"
        from          "pjointadm@gmail"
        recipients    user.email
        sent_on       Time.now
        body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
    end

    def activation_instructions(user)
        subject "Poing Joint Activation"
        from "pjointadm@gmail.com"
        recipients user.email
        sent_on Time.now
        body :account_activation_url => register_url(user.perishable_token)
    end

    def activation_confirmation(user)
        subject "PointJoint Activation Confirmation"
        from "pjointadm@gmail"
        recipients user.email
        sent_on Time.now
        body :root_url =>root_url
    end

end
