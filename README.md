# Transformer Monitoring App

## Overview
The Transformer Monitoring App is a mobile application developed using Flutter. The app provides real-time monitoring and alerting capabilities for transformer parameters such as voltage, current, temperature, and alarm statuses. It ensures timely updates and notifications for critical events to facilitate efficient transformer management.

## Key Features
1. Real-Time Data Display
    - 3-Phase Voltage: Displays voltage readings for each phase.
    - 3-Phase Current: Displays current readings for each phase.
    - Temperature Monitoring: Shows transformer temperature in real-time.
    - Alarm Indicators:
      - Oil Level Sensor: Alerts for low and high oil levels.
      - Temperature Sensor: Alerts for high and low-temperature conditions.
      - Bokhlez Sensor: Provides two specific sensor alerts.
2. Notifications for Alarms
    - Configured to alert users about critical alarm conditions such as:
      - Over-temperature.
      - Low oil level.
      - Sensor malfunctions.
    - Notifications include detailed information about the alarm (e.g., "High-Temperature Detected: 85°C").
3. MQTT Communication for Real-Time Updates
    - Uses the mqtt_client package to connect to an MQTT broker for live data updates.
    - Displays real-time data changes seamlessly within the app.

## Technical Stack:
  1. Flutter Framework
       - The app is developed using Flutter for a cross-platform, user-friendly interface.
  3. MQTT Communication
      - Package: mqtt_client.
      - Functionality: Establishes and maintains a connection to the MQTT broker, subscribes to topics, and listens for real-time transformer data updates.
  4. Push Notifications
      - Packages:
        - flutter_local_notification: Displays notifications.
        - flutter_background_service: Enables notifications to work even when the app runs in the background.
      - Features:
        - Configures and sends push notifications for alarm conditions.
  5. State Management
      - State management ensures real-time data updates and efficient UI rendering.

## Configuration
  - MQTT Broker
    - Update the MQTT broker details in the application configuration:
      - Broker URL
      - Port
      - Topics for data subscription
  - Notification Settings
    - Customize the notification messages and behavior in the notification service implementation.

## Usage
  1. Launch the app.
  2. View real-time transformer data on the dashboard, including voltage, current, and temperature.
  3. Monitor alarm indicators for sensors.
  4. Receive push notifications for any critical alarm conditions.

## Future Enhancements
  - Support for additional sensors.
  - Historical data visualization.
  - Multi-language support.
  - Advanced analytics and reporting.
