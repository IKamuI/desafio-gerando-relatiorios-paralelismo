defmodule GenReport do
  alias GenReport.Parser

  @available_users [
    "daniele",
    "mayk",
    "giuliano",
    "cleiton",
    "jakeliny",
    "joseph",
    "diego",
    "danilo",
    "rafael",
    "vinicius"
  ]

  @month_names [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro"
  ]

  @available_years [
    2016,
    2017,
    2018,
    2019,
    2020
  ]

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.map(fn line -> line end)
    |> Enum.reduce(report_acc(), fn line, report -> sum_values(line, report) end)
  end

  def build(), do: {:error, "Insira o nome de um arquivo"}

  defp sum_values([name, hours, _day, month, year], %{
         "all_hours" => all_hours,
         "hours_per_month" => hours_per_month,
         "hours_per_year" => hours_per_year
       }) do
    all_hours = sum_all_hours(all_hours, name, hours)

    hours_per_month = sum_hours_per_month(hours_per_month, name, month, hours)

    hours_per_year = sum_hours_per_year(hours_per_year, name, year, hours)

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp sum_all_hours(all_hours, name, hours) do
    Map.put(all_hours, name, all_hours[name] + hours)
  end

  defp sum_hours_per_month(hours_per_month, name, month, hours) do
    put_in(
      hours_per_month,
      [name, month],
      hours_per_month[name][month] + hours
    )
  end

  defp sum_hours_per_year(hours_per_year, name, year, hours) do
    put_in(
      hours_per_year,
      [name, year],
      hours_per_year[name][year] + hours
    )
  end

  def report_acc do
    all_hours = report_all_hours_acc()
    hours_per_month = report_hours_per_month()
    hours_per_year = report_hours_per_year()

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp report_all_hours_acc, do: Enum.into(@available_users, %{}, &{&1, 0})

  defp report_hours_per_month do
    months = Enum.into(@month_names, %{}, &{&1, 0})
    Enum.into(@available_users, %{}, &{&1, months})
  end

  defp report_hours_per_year do
    years = Enum.into(@available_years, %{}, &{&1, 0})
    Enum.into(@available_users, %{}, &{&1, years})
  end

  defp build_report(all_hours, hours_per_month, hours_per_year),
    do: %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
end
