defmodule UeberauthPasswordlessTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Ueberauth.Strategy.Passwordless

  describe "handle_request!/1" do
    test "sends an Email" do
      conn("get", "/auth/passwordless", %{email: "foo@bar.com"})
      |> Passwordless.handle_request!()

      assert_receive {:mailer_called, _magic_link, "foo@bar.com"}
    end

    test "redirects to a default url" do
      conn =
        conn("get", "/auth/passwordless", %{email: "foo@bar.com"})
        |> Passwordless.handle_request!()

      assert get_resp_header(conn, "location") == ["/?email=foo@bar.com"]
    end

    test "redirects to a provided url" do
      conn =
        conn("get", "/auth/passwordless", %{email: "foo@bar.com", redirect_url: "/foo"})
        |> Passwordless.handle_request!()

      assert get_resp_header(conn, "location") == ["/foo?email=foo@bar.com"]
    end

    test "returns an error if no email was provided" do
      conn_with_errors = conn("get", "/") |> Passwordless.handle_request!()
      error = Enum.at(conn_with_errors.assigns.ueberauth_failure.errors, 0)

      assert error.message == "No email provided"
      assert error.message_key == "missing_email"
    end
  end

  describe "handle_callback!/1" do
    test "puts the Email as private assign on the connection" do
      link = conn("get", "/") |> Passwordless.create_link("foo@bar.com")

      conn =
        conn("get", link)
        |> Plug.Conn.fetch_query_params()
        |> Passwordless.handle_callback!()

      assert conn.private.passwordless_email == "foo@bar.com"
    end

    test "returns an error if the token is invalid" do
      conn =
        conn("get", "/auth/passwordless", %{token: "foo"})
        |> fetch_query_params()
        |> Passwordless.handle_callback!()

      error = Enum.at(conn.assigns.ueberauth_failure.errors, 0)
      assert error.message == "Token was invalid"
      assert error.message_key == "invalid_token"

      refute conn.private[:passwordless_email]
    end

    test "returns an error if no token was set" do
      conn =
        conn("get", "/auth/passwordless")
        |> Passwordless.handle_callback!()

      error = Enum.at(conn.assigns.ueberauth_failure.errors, 0)
      assert error.message == "No token received"
      assert error.message_key == "missing_token"

      refute conn.private[:passwordless_email]
    end
  end

  describe "handle_cleanup!/1" do
    test "removes the email and token private assigns" do
      conn =
        conn("get", "/")
        |> put_private(:passwordless_email, "foo@bar.com")
        |> Passwordless.handle_cleanup!()

      refute conn.private.passwordless_email
    end
  end
end
