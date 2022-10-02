defmodule State do

  def initial() do
    {[],[],[]}
  end

  def add_device(state,device_info) do
    {device_list,alarm_list,data_list} = state
    new_id = find_new_id(device_list)
    new_device = %Device{id: new_id, name: device_info[:name], localisation: device_info[:localisation]}
    {"device added",{device_list ++ [new_device], alarm_list, data_list}}
  end

  def find_new_id(device_list, id \\0)
  def find_new_id([],id) do
    id
  end
  def find_new_id([_|tail],id) do
    find_new_id(tail,id+1)
  end

  def add_data(state, device_id, data) do
    {device_list,alarm_list,data_list} = state
    new_data = %Data{device_id: device_id, type:  data[:type], value: data[:value]}
    new_state = {device_list, alarm_list, data_list ++ [new_data]}
    alarm_to_raise = find_alarm_to_raise(alarm_list,new_data)
    {"data added",{new_state, new_data, alarm_to_raise}}
  end

  def find_alarm_to_raise(alarm_list,new_data,alarm_to_raise \\ [])
  def find_alarm_to_raise([],_,alarm_to_raise) do
    alarm_to_raise
  end
  def find_alarm_to_raise([head|tail],new_data,alarm_to_raise) do
    alarm_func = head.func
    case alarm_func.(new_data) do
      true -> find_alarm_to_raise(tail,new_data,alarm_to_raise ++ [head.name])
      _ -> find_alarm_to_raise(tail,new_data,alarm_to_raise)
    end
  end

  def add_alarm(state,name, pid, filter_func) do
    {device_list,alarm_list,data_list} = state
    case alarm_already_exist(alarm_list,name) do
      true -> {"alarm already exist",state}
      false ->  {"alarm added",{device_list, alarm_list ++ [%Alarm{name: name,pid: pid, func: filter_func}], data_list}}
    end
  end

  def alarm_already_exist(alarm_list, name)
  def alarm_already_exist([],_) do
    false
  end
  def alarm_already_exist([head|tail],name) do
    case name == head.name do
      true -> true
      false -> alarm_already_exist(tail,name)
    end
  end

  def find_devices(state,filter_func,found_devices \\ [])
  def find_devices({[],_,_},_,found_devices) do
    found_devices
  end
  def find_devices({[head|tail],alarm_list,data_list},filter_func,found_devices) do
    case filter_func.(head) do
      true -> find_devices({tail,alarm_list,data_list},filter_func,found_devices ++ [head.id])
      false -> find_devices({tail,alarm_list,data_list},filter_func,found_devices)
    end
  end
end
