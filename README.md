# AlarmServer CANEVET Gaspard

Project based on the second homework of the UE FIAB. This project is made of an AlarmServer module based on GenServer module. we are able to perform some calls to the server using predevelopped functions within Main module. Thus, we can:
- Add devices that can send data information like temperature or pressure to the server.
- Add users that can set server alarms and receive raised alarms from the server.
- Search for devices using information like the name or the localisation.

## Dependencies

Elixir and git need to be installed to run and test the project.

## project installation

clone the repo on a dedicated folder using the command bellow:

```cmd
project_location> git clone https://github.com/CANEVETGASPARD/alarm_server.git
```

## Compile and run 

Use your command line interpreter and move to the project directory and run the following commands.

```cmd
project_location> mix compile
Compiling 1 file (.ex)
Generated alarm_server app
```

```cmd
project_location> iex -S mix  
Interactive Elixir (1.14.0) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)>
```

Then you will be able to try the predevelopped scenarios (first/second/third_scenario) and predevelopped functions (start, stop, create_device, search_devices, send_data, create_user, set_alarm) within Main module.

# Run scenario 

- The first scenario add three devices and search for devices located in brest. Find below how to run it:

```cmd
project_location> iex -S mix  
Interactive Elixir (1.14.0) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Main.first_scenario()
[0, 2]
```

- The second scenario add three devices create one user that set up an alarm for temperature > 30°C. Then, we send some temperature data from devices and raise some alarms. Find below how to run it:

```cmd
project_location> iex -S mix  
Interactive Elixir (1.14.0) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Main.second_scenario() 
alarm named temperature threshold is raised due to temperature = 35 on device number 1
alarm named temperature threshold is raised due to temperature = 32 on device number 2
alarm named temperature threshold is raised due to temperature = 33 on device number 1
:ok
```

- The third scenario add three devices create one user that set up one alarm for temperature > 30°C and one alarm for pressure = 1bar. Then, we send some temperature and pressure data from devices and raise some alarms. Find below how to run it:

```cmd
project_location> iex -S mix  
Interactive Elixir (1.14.0) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Main.third_scenario()  
alarm named temperature threshold is raised due to temperature = 35 on device number 1
alarm named temperature threshold is raised due to temperature = 32 on device number 2
alarm named pressure value is raised due to pressure = 1 on device number 2
alarm named temperature threshold is raised due to temperature = 33 on device number 1
:ok
```

# Structure

- lib/alarm_server.ex -> callback module
- lib/alarm.ex -> alarm structure %Alarm{name,pid,func}
- lib/data.ex -> data structure %Data{device_id,type,value}
- lib/device.ex -> device structure %Device{id,name,localisation} but we can add other device description like device model
- lib/main.ex -> interface for client with predevelopped scenarios and predevelopped functions
- lib/state.ex -> state module made of functions related to state handling (add_device, add_user, find_new_id, etc...)
- test/state_test.exs -> test on state functions

## Contributing

If you want to contribute and add some device information, you can use mix test tool. To do so, you just have to put your tests within the test folder and run the command below:

```cmd
project_location> mix test
```

It will help you inspect the output of your new implementations

