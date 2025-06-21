# 🌻 Plants vs Zombies - VAT Version

A custom take on the classic **Plants vs Zombies**, built using the **Godot Engine**.

This version uses **Vertex Animation Textures (VAT)** to animate 3D models directly in the GPU shader, rather than relying on traditional skeletal animations. This allows for efficient rendering and extremely low draw calls.

![Game Demo](demo.gif) <!-- Replace 'demo.gif' with the actual file name or link -->

---

## ✨ Features

- 🧱 **ECS Architecture**: Built using an Entity Component System for managing plant and zombie prefabs.
- 🧑‍🎨 **Custom Models & Animations**: All models and animations created in Blender.
- 🎲 **Weighted Zombie Spawning**:
  - Each zombie has a spawn "cost" (e.g., 2 regular zombies = 1 strong zombie).
  - Zombies prefer lanes with the weakest defenses, encouraging adaptive gameplay.
- 🧠 **Object-Oriented Architecture**: Base `Plant` and `Zombie` classes with inheritance for extensibility.
- 🚀 **GPU Instancing**:
  - All Peashooters are instanced via the GPU (only a few draw calls total, instead of a few draw calls for each plant).
  - Individual plants can activate animations by setting parameters in the shader.
- **50/50 Rule Implemented** spawns the next wave of zombies if the current wave's health is below 50%.

---

## 🛠 Setup

1. Clone this repository (Godot 4.4+ required):
   ```bash
   git clone https://github.com/your-username/Plants-vs-zombies-VAT-version.git
