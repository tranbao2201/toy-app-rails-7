class UserMailer < ApplicationMailer

  def acount_activation user
    @user = user
    mail to: user.email, subject: "Account Activation"
  end
  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
