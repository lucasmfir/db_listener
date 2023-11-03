defmodule DBListener.Listener do
  use GenServer, restart: :permanent

  @channel "notify_age_updated"

  def start_link(init_args) do
    GenServer.start_link(__MODULE__, [init_args], name: {:global, __MODULE__})
  end

  def init(_args) do
    repo_config = DBListener.Repo.config()

    {:ok, pid} = Postgrex.Notifications.start_link(repo_config)
    {:ok, _ref} = Postgrex.Notifications.listen(pid, @channel)

    {:ok, pid}
  end

  def handle_info({:notification, _pid, _ref, @channel, payload}, state) do
    payload = Jason.decode!(payload)
    IO.inspect(payload, label: "Received an age updated notification")

    {:noreply, state}
  end
end
