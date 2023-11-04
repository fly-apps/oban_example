defmodule ObanExampleWeb.HomePageLive do
  use ObanExampleWeb, :live_view

  alias ObanExample.JobMachine

  @topic "jobs"

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: JobMachine.subscribe()
    jobs = ObanExample.Repo.replica().all(Oban.Job)

    {:ok,
     socket
     |> assign(:current_region, Fly.my_region())
     |> stream_configure(:jobs, dom_id: &("jobs-#{&1.id}"))
     |> stream_configure(:processed_jobs, dom_id: &("processed-jobs-#{&1.id}"))
     |> stream(:jobs, jobs)
     |> stream(:processed_jobs, [])}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <section class="space-y-8">
      <.header>
        Jobs
        <:subtitle>
          You're connected to <%= @current_region %>
        </:subtitle>
        <:actions>
          <.button phx-click="schedule_job">Schedule job</.button>
        </:actions>
      </.header>

      <div class="grid grid-cols-2 gap-x-12">

        <section class="space-y-4">
          <h2 class="text-2xl font-medium">Enqueued Jobs</h2>
        <ul id="jobs" phx-update="stream" class="divide-y">
          <li :for={{dom_id, job} <- @streams.jobs} id={dom_id} class="py-2">
            <dl class="grid grid-cols-2">
              <dt>ID</dt>
              <dd><%= job.id %></dd>

              <dt>Args</dt>
              <dd><%= job.args |> inspect() %></dd>

              <dt>State</dt>
              <dd><%= job.state %></dd>
            </dl>
          </li>
        </ul>
        </section>

        <section class="space-y-4">
          <h2 class="text-2xl font-medium">Processed jobs</h2>
          <ul id="processed-jobs" phx-update="stream" class="divide-y">
            <li :for={{dom_id, job} <- @streams.processed_jobs} id={dom_id} class="py-2">
              <dl class="grid grid-cols-2">
                <dt>ID</dt>
                <dd><%= job.id %></dd>

                <dt>Args</dt>
                <dd><%= job.args |> inspect() %></dd>

                <dt>State</dt>
                <dd><%= job.state %></dd>
              </dl>
            </li>
          </ul>
        </section>
      </div>
    </section>

    """
  end

  @impl true
  def handle_info({:job_enqueued, job}, socket) do
    {:noreply, stream_insert(socket, :jobs, job)}
  end

  def handle_info({:job_processed, job}, socket) do
    {:noreply,
     socket
     |> stream_insert(:processed_jobs, job, at: -1)
     |> stream_delete(:jobs, job)}
  end

  @impl true
  def handle_event("schedule_job", _params, socket) do
    JobMachine.schedule_job()
    {:noreply, socket}
  end
end
