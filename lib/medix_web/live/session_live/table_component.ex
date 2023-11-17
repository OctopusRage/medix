defmodule MedixWeb.SessionLive.TableComponent do
  use Phoenix.Component

  def custom_table(assigns) do
    ~H"""
    <div class="relative overflow-x-auto shadow-md sm:rounded-lg">
      <table class="w-full text-sm text-left rtl:text-right text-gray-500 dark:text-gray-400">
        <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
          <tr>
            <%= for col <- @col do %>
              <th scope="col" class="px-6 py-3">
                <%= col.label %>
              </th>
            <% end %>
          </tr>
        </thead>

        <tbody>
          <%= for row <- @rows do %>
            <%= if row.status == 1 do %>
              <tr class="bg-green-100 border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-red-200 dark:hover:bg-red-600">
                <%= for col <- @col do %>
                  <td class="px-6 py-4">
                    <%= render_slot(col, row) %>
                  </td>
                <% end %>
              </tr>
            <% else %>
              <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-red-200 dark:hover:bg-red-600">
                <%= for col <- @col do %>
                  <td class="px-6 py-4">
                    <%= render_slot(col, row) %>
                  </td>
                <% end %>
              </tr>
            <% end %>
          <% end %>
        </tbody>
      </table>
    </div>
    """
  end
end
