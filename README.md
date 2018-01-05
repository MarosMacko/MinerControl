# MinerControl
Keep your mining software up and running

__

How to use the MinerControl

1. Download the batch file from the github and place it to the same folder as your miner .exe file
2. Right-click the file and select 'edit'
3. Edit the user settings

  ::USER SETTINGS
  minerProcess=ccminer.exe  > Process name of your miner software (you can find it out in the Task Manager)
  checkDelay=10             > Delay (approx) between checks (can be low) in seconds
  resetFreq=1               > Delay (approx) between miner restarts in minutes (0=never)

Don't forget to change the START command with your miner settings!!

  e.g. your previous miner command was 'ccminer -o stratum+tcp://ip.xx:PORT -u adress -p x'

  >new line will be
  START ccminer -o stratum+tcp://ip.xx:PORT -u adress -p x

