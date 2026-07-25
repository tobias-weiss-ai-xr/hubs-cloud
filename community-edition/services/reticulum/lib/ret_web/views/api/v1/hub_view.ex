defmodule RetWeb.Api.V1.HubView do
  use RetWeb, :view
  alias Ret.{Hub, Scene, SceneListing, HubWorksheets}

  def render("create.json", %{hub: hub}) do
    %{
      status: :ok,
      hub_id: hub.hub_sid,
      url: hub |> Hub.url_for(),
      creator_assignment_token: hub.creator_assignment_token,
      embed_token: hub.embed_token
    }
  end

  def render("show.json", %{hub: %Hub{scene: %Scene{}} = hub, embeddable: embeddable}) do
    hub |> render_with_scene(embeddable)
  end

  def render("show.json", %{
        hub: %Hub{scene_listing: %SceneListing{}} = hub,
        embeddable: embeddable
      }) do
    hub |> render_with_scene(embeddable)
  end

  def render("show.json", %{hub: hub}) do
    hub |> render_with_scene_asset(:gltf_bundle, hub.default_environment_gltf_bundle_url)
  end

  def render_with_scene(hub, embeddable) do
    %{
      hubs: [
        %{
          hub_id: hub.hub_sid,
          name: hub.name,
          description: hub.description,
          user_data: hub.user_data,
          slug: hub.slug,
          allow_promotion: hub.allow_promotion,
          # The entry code feature has been removed. We return 0 here to
          # maintain compatibility with older clients.
          entry_code: 0,
          entry_mode: hub.entry_mode,
          host: hub.host,
          port: Ret.Hub.janus_port(),
          turn: Ret.Hub.generate_turn_info(),
          scene: RetWeb.Api.V1.SceneView.render_scene(hub.scene || hub.scene_listing, nil),
          embed_token:
            if embeddable do
              hub.embed_token
            else
              nil
            end,
          member_permissions: hub |> Hub.member_permissions_for_hub(),
          room_size: hub |> Hub.room_size_for(),
          member_count: hub |> Hub.member_count_for(),
          lobby_count: hub |> Hub.lobby_count_for()
        }
      ]
    }
  end

  def render("analytics.json", %{hub: hub, member_count: member_count, lobby_count: lobby_count, student_count: student_count, total_quiz_answers: total_quiz_answers}) do
    %{
      member_count: member_count,
      lobby_count: lobby_count,
      student_count: student_count,
      total_quiz_answers: total_quiz_answers
    }
  end

  def render("worksheets.json", %{worksheets: worksheets}) do
    %{worksheets: Enum.map(worksheets, &worksheet_json/1)}
  end

  def render("worksheet.json", %{worksheet: worksheet}) do
    worksheet_json(worksheet)
  end

  defp worksheet_json(w) do
    %{
      worksheet_id: w.worksheet_id,
      title: w.title,
      steps: w.steps,
      active: w.active,
      inserted_at: w.inserted_at
    }
  end

  defp render_with_scene_asset(hub, asset_type, asset_url) do
    %{
      hubs: [
        %{
          hub_id: hub.hub_sid,
          name: hub.name,
          description: hub.description,
          user_data: hub.user_data,
          slug: hub.slug,
          allow_promotion: hub.allow_promotion,
          # The entry code feature has been removed. We return 0 here to
          # maintain compatibility with older clients.
          entry_code: 0,
          entry_mode: hub.entry_mode,
          host: hub.host,
          port: Ret.Hub.janus_port(),
          turn: Ret.Hub.generate_turn_info(),
          topics: [
            %{
              topic_id: "#{hub.hub_sid}/#{hub.slug}",
              janus_room_id: Hub.janus_room_id_for_hub(hub),
              assets: [%{asset_type: asset_type, src: asset_url}]
            }
          ],
          member_permissions: hub |> Hub.member_permissions_for_hub(),
          room_size: hub |> Hub.room_size_for(),
          member_count: hub |> Hub.member_count_for(),
          lobby_count: hub |> Hub.lobby_count_for()
        }
      ]
    }
  end
end
