# Buffering with State Machine

- [Buffering with State Machine](#buffering-with-state-machine)
  - [Problem](#problem)
  - [Issue](#issue)
  - [Solution](#solution)
    - [Storing the buffered inputs](#storing-the-buffered-inputs)

## Problem

Buffering is the act of defering player actions at a later date, when the player is ready to act. For example, the player shoot has a 20 frames of cooldown. Pressing shot 1 frame before this cooldown comes to end currently does nothing, the input is processed but no actions is shot. With buffering, this action will be stored for X frames and fed to the input handling system until consumed.

We want to implement buffering at a variable timming : from 0 frames of buffering to X frames of buffering. The amount of buffer is defined in the player.

## Issue

Since buffering is supposed to fire input events when "lag" is over, the easiest solution is to fire the event every frames.
Godot input system works by firing input event to Node, which may or may not handle them. If the events are not handled, they are passed to child nodes. This system doesn't fire every frame, which makes buffering harder.

## Solution

### Storing the buffered inputs

In the 