# bullion/banker
poker banking automation

[Visit the App here](http://poker.tylerkontra.com)

# Purpose

Home poker games become tedious to track: who had how many chips, and how much are those chips worth?

With that problem in hand, I set out to see just how quickly I could stand up a web application.

# Overview

This app implements a minimal full-stack web app that allows the user to start a `game` specifying a buyin cash amount and corresponding chip count. Then `players` are added to the game. Each buyin can be tracked and players can cash out one or more times. Their corresponding balance is reported. 

The player balances are reported from the perspective of the banker (i.e. negative balance means the player is owed money).

Games are stored with a serial primary key that is hashed to a `shortcode`. This shortcode can be used to lookup your games if you navigate away. The url structure allows you to bookmark games.

# Architecture

- phoenix elixir app
- postgres database
- simple phoenix template html
- deployed via digital ocean server

# Roadmap

Add client-side sessions (cookies) to provide a `Your Recent Games` section on the home page to make it easy to return to previously reviewed games (without remembering a shortcode).