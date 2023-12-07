defmodule PledgeServerTest do
  use ExUnit.Case

  alias Servy.PledgeServer

  # test "accepts a pledge and returns a response" do
  #   _pid = PledgeServer.start()
  #   res = PledgeServer.create_pledge("John", 100)
  #   assert String.starts_with?(res, "pledge-")
  # end

  test "server caches 3 most recent pledges" do
    PledgeServer.start()

    PledgeServer.create_pledge("larry", 10)
    PledgeServer.create_pledge("moe", 20)
    PledgeServer.create_pledge("curly", 30)
    PledgeServer.create_pledge("daisy", 40)
    PledgeServer.create_pledge("grace", 50)

    recent_pledges = PledgeServer.recent_pledges()

    assert recent_pledges == [
             {"grace", 50},
             {"daisy", 40},
             {"curly", 30}
           ]
    assert PledgeServer.total_pledged() == 120
  end
end
