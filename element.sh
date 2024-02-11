#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# check if the argument is empty
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
# check if the argument is a number
elif [[ $1 =~ ^[0-9]+$ ]]; then
  # search for the atomic number in the database
  ELEMENT_NUMBER=$1
  ELEMENT_NAME_RESULT=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ELEMENT_NUMBER")
  # check if the name exists
  if [[ ! -z $ELEMENT_NAME_RESULT ]]
  then
    # get the other details
    ELEMENT_SYMBOL_RESULT=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ELEMENT_NUMBER")
    ELEMENT_TYPE_RESULT=$($PSQL "SELECT type FROM types LEFT JOIN properties USING(type_id) WHERE atomic_number = $ELEMENT_NUMBER")
    ATOMIC_MASS_RESULT=$($PSQL "SELECT atomic_mass FROM properties LEFT JOIN elements USING(atomic_number) WHERE atomic_number = $ELEMENT_NUMBER")
    MELTING_POINT_RESULT=$($PSQL "SELECT melting_point_celsius FROM properties LEFT JOIN elements USING(atomic_number) WHERE atomic_number = $ELEMENT_NUMBER")
    BOILING_POINT_RESULT=$($PSQL "SELECT boiling_point_celsius FROM properties LEFT JOIN elements USING(atomic_number) WHERE atomic_number = $ELEMENT_NUMBER")
    echo "The element with atomic number $ELEMENT_NUMBER is $ELEMENT_NAME_RESULT ($ELEMENT_SYMBOL_RESULT). It's a $ELEMENT_TYPE_RESULT, with a mass of $ATOMIC_MASS_RESULT amu. $ELEMENT_NAME_RESULT has a melting point of $MELTING_POINT_RESULT celsius and a boiling point of $BOILING_POINT_RESULT celsius."
  else
    echo "I could not find that element in the database."
  fi
# check if the argument is a symbol
elif [[ ${#1} == 1 || ${#1} == 2 ]]; then
  # search for the element symbol in the database
  ELEMENT_SYMBOL=$1
  ELEMENT_NAME_RESULT=$($PSQL "SELECT name FROM elements WHERE symbol = '$ELEMENT_SYMBOL'")
  # check if the name exists
  if [[ ! -z $ELEMENT_NAME_RESULT ]]
  then
    # get the other details
    ELEMENT_NUMBER_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$ELEMENT_SYMBOL'")
    ELEMENT_TYPE_RESULT=$($PSQL "SELECT type FROM types LEFT JOIN properties USING(type_id) LEFT JOIN elements USING(atomic_number) WHERE atomic_number = '$ELEMENT_NUMBER_RESULT'")
    ATOMIC_MASS_RESULT=$($PSQL "SELECT atomic_mass FROM properties LEFT JOIN elements USING(atomic_number) WHERE atomic_number = $ELEMENT_NUMBER_RESULT")
    MELTING_POINT_RESULT=$($PSQL "SELECT melting_point_celsius FROM properties LEFT JOIN elements USING(atomic_number) WHERE atomic_number = $ELEMENT_NUMBER_RESULT")
    BOILING_POINT_RESULT=$($PSQL "SELECT boiling_point_celsius FROM properties LEFT JOIN elements USING(atomic_number) WHERE atomic_number = $ELEMENT_NUMBER_RESULT")
    echo "The element with atomic number $ELEMENT_NUMBER_RESULT is $ELEMENT_NAME_RESULT ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE_RESULT, with a mass of $ATOMIC_MASS_RESULT amu. $ELEMENT_NAME_RESULT has a melting point of $MELTING_POINT_RESULT celsius and a boiling point of $BOILING_POINT_RESULT celsius."
  else
    echo "I could not find that element in the database."
  fi
else
  # search for the element name in the database
  ELEMENT_NAME=$1
  ELEMENT_NUMBER_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$ELEMENT_NAME'")
  # check if the name exists
  if [[ ! -z $ELEMENT_NUMBER_RESULT ]]
  then
    ELEMENT_SYMBOL_RESULT=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ELEMENT_NUMBER_RESULT")
    ELEMENT_TYPE_RESULT=$($PSQL "SELECT type FROM types LEFT JOIN properties USING(type_id) LEFT JOIN elements USING(atomic_number) WHERE atomic_number = '$ELEMENT_NUMBER_RESULT'")
    ATOMIC_MASS_RESULT=$($PSQL "SELECT atomic_mass FROM properties LEFT JOIN elements USING(atomic_number) WHERE atomic_number = $ELEMENT_NUMBER_RESULT")
    MELTING_POINT_RESULT=$($PSQL "SELECT melting_point_celsius FROM properties LEFT JOIN elements USING(atomic_number) WHERE atomic_number = $ELEMENT_NUMBER_RESULT")
    BOILING_POINT_RESULT=$($PSQL "SELECT boiling_point_celsius FROM properties LEFT JOIN elements USING(atomic_number) WHERE atomic_number = $ELEMENT_NUMBER_RESULT")
    echo "The element with atomic number $ELEMENT_NUMBER_RESULT is $ELEMENT_NAME ($ELEMENT_SYMBOL_RESULT). It's a $ELEMENT_TYPE_RESULT, with a mass of $ATOMIC_MASS_RESULT amu. $ELEMENT_NAME has a melting point of $MELTING_POINT_RESULT celsius and a boiling point of $BOILING_POINT_RESULT celsius."
  else
    echo "I could not find that element in the database."
  fi
fi
