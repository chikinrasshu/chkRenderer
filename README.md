# chkRenderer
Simple 3D renderer in Swift for macOS

Features a simple Scene graph of Node objects.

```mermaid
graph BT;
  Triangle & Plane & Cube --> Primitive;
  
  Primitive & Scene & Empty --> Node;
  Primitive -.-> Renderable & Texturable;
```

TODO List:
  - Render 3D models in OBJ format
  - Make a simple scene editor mode
  - Add Keyboard controls
  - Add Mouse controls
  - Make some relatively complex scene for testing.
