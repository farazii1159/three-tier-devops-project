#!/bin/bash

# --- Server Performance Stats ---

echo "=========================================="
echo "      SERVER PERFORMANCE STATS            "
echo "=========================================="

# 1. Total CPU Usage
# Using 'top' in batch mode and grabbing the idle percentage
cpu_idle=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
echo "Total CPU Usage: $cpu_idle%"

# 2. Memory Usage (Free vs Used)
# Parsing 'free -m' output
free_mem=$(free -m | awk '/Mem:/ {print $4}')
used_mem=$(free -m | awk '/Mem:/ {print $3}')
total_mem=$(free -m | awk '/Mem:/ {print $2}')
mem_perc=$(awk "BEGIN {printf \"%.2f\", ($used_mem/$total_mem)*100}")
echo "Memory Usage: $used_mem MB used / $free_mem MB free ($mem_perc%)"

# 3. Disk Usage (Free vs Used)
# Parsing 'df -h' for the root filesystem
disk_usage=$(df -h / | awk 'NR==2 {print $3 " / " $2 " (" $5 ")"}')
echo "Disk Usage: $disk_usage"

# 4. Top 5 Processes by CPU usage
echo -e "\nTop 5 Processes by CPU Usage:"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6

# 5. Top 5 Processes by Memory usage
echo -e "\nTop 5 Processes by Memory Usage:"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6

echo -e "\n=========================================="
