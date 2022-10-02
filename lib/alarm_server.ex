defmodule AlarmServer do
  @moduledoc """
  Documentation for `AlarmServer`.
  """

  use GenServer

  @doc """
  """
  def init(_) do
    {:ok,State.initial()}
  end

  def handle_cast(:stop,state) do
      {:stop,:normal,state}
  end
  def handle_cast({:data,id,data},state) do
    {_,{new_state,new_data,alarm_to_raise}} = State.add_data(state,id,data)
    raise_alarm(alarm_to_raise,new_data,new_state)
    {:noreply,new_state}
  end

  def handle_call({:register,infos},_,state) do
    {message,new_state} = State.add_device(state,infos)
    {:reply,message,new_state}
  end
  def handle_call({:set_alarm, pid, name, filter_fun},_,state) do
    {message,new_state} = State.add_alarm(state,name,pid,filter_fun)
    {:reply,message,new_state}
  end

  def handle_call({:search, filter_fun},_,state) do
    found_device = State.find_devices(state,filter_fun)
    {:reply,found_device,state}
  end

  def raise_alarm(alarm_to_raise,new_data,state)
  def raise_alarm([],_,_) do
    :ok
  end
  def raise_alarm([head|tail],new_data,state) do
    {_,alarm_list,_} = state
    alarm = Enum.find(alarm_list, fn alarm -> alarm.name == head end)
    send(alarm.pid,{:alarm,head,new_data})
    raise_alarm(tail,new_data,state)
  end
end
