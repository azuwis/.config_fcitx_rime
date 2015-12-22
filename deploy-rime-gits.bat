del "%appdata%\Google\Google Input Tools\Rime\default.yaml"
net stop GoogleInputService
tskill /v GoogleInputHandler
net start GoogleInputService
