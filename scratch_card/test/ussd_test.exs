defmodule UssdTest do
  use ExUnit.Case
  alias ScratchCard.Ussd

  describe "test ussd start Menu" do
    menu = Ussd.start_session()

    session = "session_10001"
    %{menu: response_menu} = ExUssd.Utils.navigate("", menu, session)
    get_menu = ExUssd.get_menu(session_id: session)
    assert response_menu.title == get_menu.title
  end

  describe "dial *141# " do
    menu = Ussd.start_session()

    assert ExUssd.simulate(menu: menu, text: "*141#", service_code: "*141#") ==
             {:ok,
              %{
                menu_string:
                  "You have entered an incorrect format.\nPlease check and try again. For recharge dial *141*recharge voucher PIN# ok. Thank you.",
                should_close: true
              }}
  end

  describe "dial with incorrect voucher_number" do
    menu = Ussd.start_session()

    assert ExUssd.simulate(menu: menu, text: "*141*1#", service_code: "*141#") ==
             {:ok,
              %{
                menu_string:
                  "Sorry we are unable to complete your request at the moment. Please try again later",
                should_close: true
              }}
  end

  describe "dial with valid voucher_number" do
    menu = Ussd.start_session()

    assert ExUssd.simulate(menu: menu, text: "*141*123456789#", service_code: "*141#") ==
             {:ok, %{menu_string: "Recharge successful, thank you.", should_close: true}}
  end
end
