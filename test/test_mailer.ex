defmodule TestMailer do
  @behaviour Ueberauth.Strategy.Passwordless.Mailer

  def send_email(magic_link, email_address) do
    send(self(), {:mailer_called, magic_link, email_address})
  end
end
