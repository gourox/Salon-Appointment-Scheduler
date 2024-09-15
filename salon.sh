#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~ My Salon ~~~~\n"

MENU(){
  if [[ -z $1 ]]
  then
  echo -e "\nWelcome to My Salon. How may I help you?\n"
  else
  echo -e "\n$1\n"
  fi

  echo -e "\n1) haircut\n2) manicure\n3) pedicure\n"

  read SERVICE_ID_SELECTED
  SERVICE_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  #if the selected service is not found
  if [[ -z $SERVICE_SELECTED ]]
  then
    #send to main menu
    MENU "I could not find that service. What would you like today?"
  else
    #ask for phone number
    echo -e "\nWhat is your phone number?\n"
    read CUSTOMER_PHONE
    #search name on the customers table
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    #if it isn't found
    if [[ -z $CUSTOMER_NAME ]]
    then
      #ask for name
      echo -e "\nWhat is your name?\n"
      read CUSTOMER_NAME
      #add it to the table
      INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    fi
    #get customer_id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    #ask for time
    echo -e "\nWhen would you like to schedule your appointment?\n"
    read SERVICE_TIME
    #insert into appointments table
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED,'$SERVICE_TIME')")

    echo -e "\nI have put you down for a $(echo $SERVICE_SELECTED | sed -r 's/^ *| *$//g')" at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."\n"


  fi
  
}

MENU

