#!/bin/bash

total_attempts=0
correct_attempts=0
incorrect_attempts=0
last_numbers=()
correct_numbers=()

while true; do
    # Generate a random number in the range [0, 9]
    secret_number=$((RANDOM % 10))

    # Prompt user for input
    read -p "Шаг $((total_attempts + 1)): Введите число от 0 до 9 (q для выхода): " user_input

    # Check if the user wants to quit
    if [ "$user_input" == "q" ]; then
        echo "Игра завершена. Спасибо за участие!"
        break
    fi

    # Validate user input
    if ! [[ "$user_input" =~ ^[0-9]$ ]]; then
        echo "Ошибка! Введите корректное однозначное число от 0 до 9."
        continue
    fi

    # Increment total attempts
    ((total_attempts++))

    # Check if the guess is correct
    if [ "$user_input" -eq "$secret_number" ]; then
        ((correct_attempts++))
        echo -e "\e[32mВерно! Загаданное число: $secret_number\e[0m"
        correct_numbers+=(1)
    else
        ((incorrect_attempts++))
        echo -e "\e[31mНеверно. Загаданное число: $secret_number\e[0m"
        correct_numbers+=(0)
    fi

    # Update last numbers array
    last_numbers+=("$user_input")
    if [ "${#last_numbers[@]}" -gt 10 ]; then
        unset 'last_numbers[0]'
        last_numbers=("${last_numbers[@]}")
        unset 'correct_numbers[0]'
        correct_numbers=("${correct_numbers[@]}")
    fi

    # Display statistics
    echo "Статистика игры:"
    echo "Угаданных чисел: $correct_attempts $((correct_attempts * 100 / total_attempts))%"
    echo "Неверных чисел: $incorrect_attempts $((incorrect_attempts * 100 / total_attempts))%"
    echo "Последние 10 чисел: "

    index=0
    while [ "$index" -lt "${#last_numbers[@]}" ]; do
    num="${last_numbers[index]}"
    cor="${correct_numbers[index]}"

    if [ "$cor" -eq 1 ]; then
        echo -n -e "\e[32m$num\e[0m "  # Зеленый цвет для числа 1
    elif [ "$cor" -eq 0 ]; then
        echo -n -e "\e[31m$num\e[0m "  # Красный цвет для числа 0
    else
        echo "$num"
    fi

    ((index++))
    done
    echo ""
done
