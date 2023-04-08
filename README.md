# CosmoExplorer
- Clone the repository
- Open CosmoDeviceExplorer.xcodeproj
- In 'Signing and Capabilities', Select a team
- Launch on an iOS device

# Cosmo devices
- Display data from the Cosmo API's devices endpoint
- Each list item opens a new screen with detailed information about the selected device

# Nearby devices
- Detects nearby Bluetooth devices, connects to them, and displays the discovered characteristics
- Only devices with a name are displayed, it can easily be changed but I took this decision to be able to demonstrate how to unit test this case
- The first time a device is detected a celebration message is displayed, it is to motivate the user to scan for new devices everyday !
