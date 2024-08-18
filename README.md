## Description

The **Device Onboarding Tool (DOT)** is a custom-built, portable provisioning solution for the onboarding of desktops and laptops intended for use at Agilent Solutions Incorporated (ASI) sites, including those within the New York City Department of Education (NYCDOE). This tool automates the configuration and setup of devices during the initial system setup, ensuring they are ready for deployment. It is designed to streamline the process, reducing the time and effort required while ensuring consistency across devices.

## Motivation

This project was developed to address the need for a more efficient and error-free process of device onboarding within ASI and NYCDOE. Traditionally, onboarding devices has been a manual, time-consuming process prone to errors. By automating this process, DOT reduces the manual work involved, ensuring devices are consistently set up according to organizational standards.

## Problem Solved

DOT solves the problem of manual configuration and setup of devices during the system's initial setup phase. The tool ensures that devices are quickly and correctly configured, significantly reducing the chances of human error and speeding up the onboarding process.

## Tech Stack

The following technologies were used in this project:

- **Operating System:** Windows 11
- **Programming Language:** Windows Batch Script
- **System Tools:** WMIC, Net Session

## Demonstration

![GIF showing usage of the tool](https://github.com/JONESTU/DOT/blob/main/demo.gif?raw=true)

*This GIF demonstrates how to run DOT during the initial setup of a Windows 11 system.*

## Features

- **Automated Configuration**: Automatically configures devices during the initial setup phase using predefined scripts.
- **Portable Solution**: The tool can be run directly from a USB drive, making it easy to deploy across multiple devices.
- **Error Handling**: The tool includes robust error handling mechanisms to ensure that any issues encountered during the onboarding process are automatically addressed, minimizing interruptions and ensuring a smooth setup.

## Setup and Usage Instructions

Follow these steps to set up and use the Device Onboarding Tool:

### 1. Preparing the USB Drive

1. Clone the repository:
   ```bash
   git clone https://github.com/JONESTU/DOT.git
   ```
2. Navigate to the directory of the cloned repository:
   ```bash
   cd DOT
   ```
3. Transfer the program to the root of your USB drive:
   - Copy the main program file(s) from the cloned directory to the root of your USB drive.

### 2. Onboarding a Device

1. Plug the USB drive into the PC that you want to onboard.
2. Start the initial setup on the Windows 11 PC.
3. Open Command Prompt during the setup (press `Shift + F10` to do so).
4. Use `explorer` in Command Prompt to open the file explorer:
   ```cmd
   explorer
   ```
   - Locate your USB drive in the file explorer window.
5. Navigate to the program file on the USB drive.
6. Right-click on the program file and select "Run as administrator."
7. Follow the prompts provided by the tool to complete the onboarding process.

## License

This project is licensed under the [Apache License 2.0](https://github.com/JONESTU/DOT/blob/main/LICENSE).
