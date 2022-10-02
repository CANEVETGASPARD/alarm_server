defmodule StateTest do
  use ExUnit.Case
  doctest State

  test "init state" do
    assert State.initial() == {[],[],[]}
  end

  test "add device" do
    assert State.add_device({[],[],[]},%{:name => "device1", :localisation => "home"}) == {"device added", {[%Device{id: 0, name: "device1", localisation: "home"}], [], []}}
    assert State.add_device({[%Device{id: 0, name: "device1", localisation: "home"}], [], []},%{:name => "device2", :localisation => "home"}) == {"device added", {[%Device{id: 0, name: "device1", localisation: "home"},%Device{id: 1, name: "device2", localisation: "home"}], [], []}}
    assert State.add_device({[],[],[]},%{:name => "device1"}) == {"device added", {[%Device{id: 0, name: "device1", localisation: nil}], [], []}}
  end

  test "find alarm to raise" do
    assert State.find_alarm_to_raise([%Alarm{name: "test", func: fn data -> data.type == :temperature and data.value > 30 end}],%Data{device_id: 0,type: :temperature,value: 25}) == []
    assert State.find_alarm_to_raise([%Alarm{name: "test", func: fn data -> data.type == :temperature and data.value > 30 end}],%Data{device_id: 0,type: :temperature,value: 35}) == ["test"]
  end

  test "add data" do
    assert State.add_data({[%Device{id: 0, name: "device1", localisation: "home"}], [], []},0,%{:type => :temperature, :value => 25}) == {"data added",{{[%Device{id: 0, name: "device1", localisation: "home"}], [], [%Data{device_id: 0,type: :temperature, value: 25}]}, %Data{device_id: 0,type: :temperature, value: 25}, []}}
  end

  test "add alarm" do
    assert State.add_alarm({[], [], []},"test_alarm","pid","func") == {"alarm added", {[], [%Alarm{name: "test_alarm",pid: "pid", func: "func"}], []}}
    assert State.add_alarm({[], [%Alarm{name: "test_alarm",pid: "pid", func: "func"}], []},"test_alarm","pid","func") == {"alarm already exist", {[], [%Alarm{name: "test_alarm",pid: "pid", func: "func"}], []}}
  end

  test "find devices" do
    assert State.find_devices({[%Device{id: 0, name: "device1", localisation: "home"}],[],[]},fn device -> device.localisation == "home" end) == [0]
    assert State.find_devices({[%Device{id: 0, name: "device1", localisation: "home"}],[],[]},fn device -> device.localisation == "outside" end) == []
    assert State.find_devices({[%Device{id: 0, name: "device1", localisation: "home"},%Device{id: 1, name: "device2", localisation: "home"}],[],[]},fn device -> device.localisation == "home" end) == [0, 1]
  end
end
