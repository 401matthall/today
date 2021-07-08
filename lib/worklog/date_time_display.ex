defmodule Today.DateTimeDisplay do

  require Logger
  def format_with_timezone(date, timezone) do
    case date |> Timex.Timezone.convert(timezone) |> Timex.format("%F %T %z", :strftime) do
      {:ok, formatted_date} -> formatted_date
      {:error, {error_type, message}} -> Logger.info(error_type); Logger.info(message); date;
      {:error, message} -> Logger.info(message); date;
    end
  end
end
