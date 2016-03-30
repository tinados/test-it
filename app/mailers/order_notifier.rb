class OrderNotifier < ApplicationMailer
  default from: 'Sam Ruby <depot@example.com>'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_notifier.received.subject
  #
  def submitted(order)
    @order = order
    mail(to: @order.email, subject: 'Store Order Confirmation')
  end

  def unsubmitted(order)
    @order = order
    mail(to: @order.email, subject: 'Store Order Confirmation')
  end
end
