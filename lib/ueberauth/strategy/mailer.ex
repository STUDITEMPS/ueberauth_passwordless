defmodule Ueberauth.Strategy.Passwordless.Mailer do
  @moduledoc """
  Defines the behaviour required by the Passwordless strategy
  in order to send emails.

  In order to send Emails from your Passwordless Strategy,
  you must define a module which implements the behaviour
  specified in this module.

  ### Setup

  Create a Module which implements the behaviour specified in this module.
  This Example uses the Bamboo Library:

    defmodule MyApp.MyMailerModule do
      @behaviour Ueberauth.Strategy.Passwordless.Mailer

      use Bamboo.Mailer, otp_app: :my_app
      import Bamboo.Email

      def send_email(magic_link, email_address) do
        new_email(to: email_address, text_body: "Your login link: " <> magic_link)
        |> deliver_later()
      end
    end

    Include the Mailer module in your Strategy configuration.

      config :ueberauth, Ueberauth.Strategy.Passwordless.Mailer,
        mailer: MyApp.MyMailerModule

  """
  @callback send_email(magic_link :: String.t(), email_address :: String.t()) :: no_return()
end
