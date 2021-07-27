defmodule TodayWeb.LiveComponent.NewWorklogModalLive do
  @moduledoc """
  """
  use TodayWeb, :live_component

  # render modal
  @spec render(map()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~L"""
    <div id="modal-<%= @id %>" phx-window-keydown="hide_new_worklog_modal" phx-key="escape">
      <!-- Modal Background -->
      <div class="modal-container" phx-capture-click="hide_new_worklog_modal" >
        <div class="modal-inner-container">
          <div class="modal-card">
            <div class="modal-inner-card">
              <!-- Body -->
              <div class="modal-body">
                <div class="flex items-center justify-center">
                  <div class="bg-gray-700 shadow-lg rounded-lg px-8 pt-6 pb-8 mb-4 w-2/5-md w-full-sm">
                    <!-- Title -->
                    <div class="modal-title">
                      <h2 class="flex justify-center mb-2 font-bold text-lg">New Worklog<h2>
                    </div>
                    <%= f = form_for :worklog, "#", id: "create-worklog-form", phx_change: nil, phx_submit: "create_worklog" %>
                      <div class="mb-6">
                        <%= label f, :title, class: "text-gray-400 font-bold mb-2" %>
                        <%= text_input f, :title, autofocus: "true",class: "shadow appearance-none border rounded w-full py-2 px-2 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" %>
                        <%= error_tag f, :title %>
                        <span class="text-gray-500 text-sm"><em>optional</em></span>
                      </div>

                      <div class="mb-6">
                        <%= label f, :body, class: "text-gray-400 font-bold mb-2" %>
                        <%= textarea f, :body, class: "shadow appearance-none border rounded w-full py-2 px-2 text-gray-700 leading-tight focus:outline-none focus:shadow-outline", rows: "8" %>
                        <%= error_tag f, :body %>
                        <span class="text-gray-500 text-sm"><em><a href="https://www.markdownguide.org/basic-syntax/" target="_blank" class="hover:underline">Markdown</a> styling works in this field</em></span>
                      </div>

                      <div class="mb-6">
                        <%= label f, :tags, class: "text-gray-400 font-bold mb-2" %>
                        <%= text_input f, :tags, class: "shadow appearance-none border rounded w-full py-2 px-2 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" %>
                        <%= error_tag f, :tags %>
                        <span class="text-gray-500 text-sm"><em>optional</em></span>
                      </div>
                      <div class="modal-buttons">
                        <div class="flex items-center justify-center">
                          <div class="btn bg-gray-800 hover:bg-gray-600 clickable m-1" phx-click="hide_new_worklog_modal">Cancel</div>
                          <%= submit "Save", phx_disable_with: "Saving worklog...", class: "btn btn-blue" %>
                        </div>
                      </div>
                    </form>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end

  def update(%{id: _id} = assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

end
