# Ueberauth Passwordless
> A Passwordless Strategy for Ueberauth using Magic Links

A full documentation can be found in the [Strategy](https://github.com/STUDITEMPS/ueberauth_passwordless/blob/master/lib/ueberauth/strategy/passwordless.ex) itself.

## Installation
1. Add `:ueberauth_passwordless` to dependencies in `mix.exs`
```elixir
  def deps do
    [
      {:ueberauth_passwordless, "~> 0.1},
    ]
  end
```

2. Create a Mailer Module, which sends the emails with the magic links:
```elixir
defmodule MyApp.MyMailer do
  @behaviour Ueberauth.Strategy.Passwordless.Mailer

  def send_email(magic_link, email_address) do
    # Send an Email containing the `magic_link` to the given `email_address`
  end
end
```

3. Add Ueberauth Passwordless to your Ueberauth configuration:
```elixir
config :ueberauth, Ueberauth,
  providers: [
    passwordless: {Ueberauth.Strategy.Passwordless, []}
  ]
```

4. Set a `token_secret` and `mailer` on your Passwordless configuration:
```elixir
config :ueberauth, Ueberauth.Strategy.Passwordless,
  token_secret: System.get_env("PASSWORDLESS_TOKEN_SECRET"),
  mailer: MyApp.MyMailer

  (optional) ttl: # Specify in Seconds how long a Magic Link should be valid
  (optional) redirect_url: # Specify a default url or path to which the conn is redirected after the Email is sent
```

5. If you haven't already, create a Controller that handles the callbacks:
```elixir
defmodule MyApp.AuthController do
  use MyApp.Web, :controller

  plug Ueberauth

  def callback(%{assigns: %{ueberauth_failure: errors}} = conn, _params) do
    # do things with the failure
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    # do things with the auth
  end

end
```

6. If you haven't already, set up the routes for authentication
```elixir
scrope "/auth" do
  pipe_through :browser
  
  get "/:provider", AuthController, :request
  get "/:provider/callback", AuthController, :callback
end
```

## Calling
Depending on your routes, you can call the passwordless strategy with e.g.:
```
/auth/passwordless?email=foo@bar.com
```

Or, from a Phoenix Form:
```elixir
<%= form_for @conn, Routes.auth_path(@conn, :request, "passwordless"), [method: get], fn f -> %>
  <%= text_input f, :email %>
  <%= submit "Submit" %>
<% end %>
```

You can optionally pass a `redirect_url` to which the conn will be redirected after the email was sent:
```
/auth/passwordless?email=foo@bar.com&redirect_url=/my-redirect-path
```

Or, from a Phoenix Form:
```elixir
<%= form_for @conn, Routes.auth_path(@conn, :request, "passwordless"), [method: get], fn f -> %>
  <%= hidden_input f, :redirect_url, value: "/my-redirect-path"%>
  <%= text_input f, :email %>
  <%= submit "Submit" %>
<% end %>
```

## TODOs:
- [ ] Ensure that a magic link can only be used once (e.g. using an `:ets` table)
- [ ] Make `ttl` an option in `handle_request!` and persist the option for when the magic link is validated