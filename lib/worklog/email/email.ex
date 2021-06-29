defmodule Today.Email do
    use Bamboo.Phoenix, view: TodayWeb.EmailView
    import Bamboo.Email

    def validation_email(to_address, token) do
      base_email()
      |> to(to_address)
      |> subject("Worklog - Validation")
      |> render("validation_email.html", token: token)
    end

    defp base_email do
      new_email()
      |> from("no-reply@Today.net")
      # This will use the "email.html.eex" file as a layout when rendering html emails.
      # Plain text emails will not use a layout unless you use `put_text_layout`

    end
  end
