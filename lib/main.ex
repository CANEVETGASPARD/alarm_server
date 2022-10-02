defmodule Main do
  @server_name :alarm
  @server_module AlarmServer

  def start_server() do
    GenServer.start(@server_module, nil, name: @server_name)
    :ok
  end

  def stop() do
    GenServer.cast(@server_name,:stop)
  end

  def create_device(device_name,device_localisation) do
    GenServer.call(@server_name, {:register,%{:name => device_name, :localisation => device_localisation}})
  end

  def search_devices(func) do
    GenServer.call(@server_name,{:search,func})
  end

  def send_data(id,data_type,data_value) do
    GenServer.cast(@server_name, {:data,id,%{:type => data_type, :value => data_value}})
  end

  def create_user() do
    spawn(Main,:listen_alarm, [])
  end

  def listen_alarm() do
    receive do
      {:alarm, alarm_name, alarming_data} ->
        IO.puts("alarm named " <> alarm_name <> " is raised due to " <> to_string(alarming_data.type) <> " = " <> to_string(alarming_data.value) <> " on device number " <> to_string(alarming_data.device_id))
        listen_alarm()
    end
  end

  def set_alarm(pid,filter_name,filter_type,filter_comparator,filter_value) do
    case filter_comparator do
      "=" -> GenServer.call(@server_name,{:set_alarm,pid,filter_name,fn data -> data.type == filter_type and data.value == filter_value end})
      "!=" -> GenServer.call(@server_name,{:set_alarm,pid,filter_name,fn data -> data.type == filter_type and data.value != filter_value end})
      "<" -> GenServer.call(@server_name,{:set_alarm,pid,filter_name,fn data -> data.type == filter_type and data.value < filter_value end})
      "<=" -> GenServer.call(@server_name,{:set_alarm,pid,filter_name,fn data -> data.type == filter_type and data.value <= filter_value end})
      ">" -> GenServer.call(@server_name,{:set_alarm,pid,filter_name,fn data -> data.type == filter_type and data.value > filter_value end})
      ">=" -> GenServer.call(@server_name,{:set_alarm,pid,filter_name,fn data -> data.type == filter_type and data.value >= filter_value end})
    end
  end

  def first_scenario() do
    start_server()
    create_device("device0","brest")
    create_device("device1","nantes")
    create_device("device2","brest")
    search_devices(fn device -> device.localisation == "brest" end)
    stop()
  end


  def second_scenario() do
    start_server()
    create_device("device0","brest")
    create_device("device1","nantes")
    create_device("device2","brest")
    user1 = create_user()
    set_alarm(user1,"temperature threshold",:temperature,">",30)
    send_data(0,:temperature, 20)
    send_data(1,:temperature, 35)
    send_data(2,:temperature, 32)
    send_data(2,:temperature, 24)
    send_data(1,:temperature, 33)
    stop()
  end

  def third_scenario() do
    start_server()
    create_device("device0","brest")
    create_device("device1","nantes")
    create_device("device2","brest")
    user1 = create_user()
    set_alarm(user1,"temperature threshold",:temperature,">",30)
    set_alarm(user1,"pressure value",:pressure,"=",1)
    send_data(0,:temperature, 20)
    send_data(0,:pressure,0.1)
    send_data(1,:temperature, 35)
    send_data(1,:pressure,1.2)
    send_data(2,:temperature, 32)
    send_data(2, :pressure, 0.3)
    send_data(2,:temperature, 24)
    send_data(2,:pressure,1)
    send_data(1,:temperature, 33)
    stop()
  end
end
