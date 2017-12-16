defmodule ExAws.CloudwatchLogs do
  @moduledoc """
  Documentation for ExAwsCloudwatchLogs.
  """

  import ExAws.Utils, only: [camelize_keys: 1]

  @namespace "Logs_20140328"

  @doc """
  Create a log group with the given name.

  ## Examples

      ExAws.CloudwatchLogs.create_log_group("my-group")
      |> ExAws.request

  """
  def create_log_group(group_name) do
    request(:create_log_group, %{"logGroupName" => group_name})
  end

  @doc """
  Create a log stream with the given name for the given log group.

  ## Examples

      ExAws.CloudwatchLogs.create_log_stream("my-group", "my-stream")
      |> ExAws.request

  """
  def create_log_stream(group_name, stream_name) do
    data = %{"logGroupName" => group_name, "logStreamName" => stream_name}
    request(:create_log_stream, data)
  end

  @doc """
  Delete the log group with the given name as well as all related log streams
  and log events.

  ## Examples

      ExAws.CloudwatchLogs.delete_log_group("my-group")
      |> ExAws.request

  """
  def delete_log_group(group_name) do
    request(:delete_log_group, %{"logGroupName" => group_name})
  end

  @doc """
  Delete the log stream with the given name in the given group.

  ## Examples

      ExAws.CloudwatchLogs.delete_log_stream("my-group", "my-stream")
      |> ExAws.request

  """
  def delete_log_stream(group_name, stream_name) do
    data = %{"logGroupName" => group_name, "logStreamName" => stream_name}
    request(:delete_log_stream, data)
  end

  @doc """
  List log groups.

  ## Examples

      ExAws.CloudwatchLogs.describe_log_groups()
      |> ExAws.request

  """
  def describe_log_groups(opts \\ []) do
    data =
      opts
      |> Map.new
      |> camelize_keys

    request(:describe_log_groups, data)
  end

  @doc """
  List the log streams for the given log group.

  ## Examples

      ExAws.CloudwatchLogs.describe_log_streams("my-group")
      |> ExAws.request

  """
  def describe_log_streams(group_name, opts \\ %{}) do
    data =
      opts
      |> Map.new
      |> camelize_keys
      |> Map.merge(%{"logGroupName" => group_name})


    request(:describe_log_streams, data)
  end

  @doc """
  List the log events from the given log stream.

  ## Examples

      ExAws.CloudwatchLogs.get_log_events("my-group", "my-stream")
      |> ExAws.request

  """
  def get_log_events(group_name, stream_name, opts \\ []) do
    data =
      opts
      |> camelize_keys
      |> Map.merge(%{"logGroupName" => group_name, "logStreamName" => stream_name})

    request(:get_log_events, data)
  end

  @doc """
  Write the log events to the given log stream.

  ## Examples

      ExAws.CloudwatchLogs.put_log_events("my-group", "my-stream", events)
      |> ExAws.request

  """
  def put_log_events(group_name, stream_name, events, opts \\ []) do
    data =
      opts
      |> Map.new
      |> camelize_keys
      |> Map.merge(%{"logEvents" => events, "logGroupName" => group_name, "logStreamName" => stream_name})

    request(:put_log_events, data)
  end

  defp request(action, data, opts \\ %{}) do
    operation =
      action
      |> Atom.to_string
      |> Macro.camelize

    ExAws.Operation.JSON.new(:logs, %{
      data: data,
      headers: [
        {"x-amz-target", "#{@namespace}.#{operation}"},
        {"content-type", "application/x-amz-json-1.1"}
      ]
    } |> Map.merge(opts))
  end
end
