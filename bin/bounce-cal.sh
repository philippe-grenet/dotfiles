#!/bin/zsh

echo "launchctl stop com.apple.CalendarAgent"
launchctl stop com.apple.CalendarAgent

echo "launchctl start com.apple.CalendarAgent"
launchctl start com.apple.CalendarAgent
