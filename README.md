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
Generated expression_parser app
```

```cmd
project_location> iex -S mix  
Interactive Elixir (1.14.0) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)>
```

Then you will be able to try the predevelopped scenarios (first/second/third_scenario) and predevelopped functions (start, stop, create_device, search_devices, send_data, create_user, set_alarm) within Main module.


