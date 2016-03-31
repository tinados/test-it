class UserMailer < ApplicationMailer
  def all_orders_email(user)
    @user = user
    attachments['file.csv'] = Order.as_csv
    mail(to: @user.email, subject: 'List of orders')
  end
end
