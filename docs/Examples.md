---
title: Examples
---

# Examples

## Simple Idle Animation

We can make a Model (in this case a Humanoid character) have an idling animation
Create a script under the Model

1. Ensure the animation you create is looped
2. Ensure your Motus module is somewhere the script can access

Copy and paste this into the Script:

```lua
local Motus = require(game.ReplicatedStorage.Motus) -- For this example, Motus is under ReplicatedStorage

local Character = script.Parent

local Animator = Motus.new(Character)
local Animation = Character.IdleAnimation -- The animation is located inside the character

-- Either 3 of the below is valid for Motus

Animator:Play(Animation) -- Plays the animation object
Animator:Play("rbxassetid://1234567890") -- Plays the animation which has an ID of 1234567890
Animator:Play(1234567890) -- Plays the animation which has an ID of 1234567890

```

## Animate whilst key is down

We can make our own Player do an animation whilst a key is down.
For example, I create an animation that has the player's arms rotate, and it's looped, and it will play whenever the [E] key is held down

Create a LocalScript inside StarterPlayerScripts and copy and paste this into the Script:

```lua
local Motus = require(game.ReplicatedStorage.Motus) -- For this example, Motus is under ReplicatedStorage

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local UserInputService = game:GetService("UserInputService")

local Animator = Motus.new(Character)
local Animation = "rbxassetid://1234567890" -- Our animation for example

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        Animator:Play(Animation)
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        Animator:Stop(Animation)
    end
end)

```

## Bonus: Cleanup when Player dies

We can cleanup our Motus Animator once the player dies, if we were to make an animation script that runs inside of the Character

```lua
local Motus = require(game.ReplicatedStorage.Motus) -- For this example, Motus is under ReplicatedStorage

local Character = script.Parent

local Animator = Motus.new(Character)

Character.Humanoid.Died:Once(function()
    Motus:Destroy() -- Cleans up and removes all cached animations to prevent memory leaks
end)

```
