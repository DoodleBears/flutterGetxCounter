# A Flutter Counter Project using GetX
See flutter package
[GetX pub.dev](https://pub.dev/packages/get)
[GetX GitHub](https://github.com/jonataslaw/getx)

## Learning GetX with simple flutter counter project
You might have seen the flutter demo project, the counter project.
![demo](image/demo.png)
Here is an easy implemantation of it using flutter, with
- print() message in console for understanding when widget build
  - you can add print() in the flutter demo project to see when click floatting button, which widget will be rebuild (it rebuild the whole HomePage, that cost a lot)
- using GetBuilder, GetX, Obx to display different counter in one page
- SIMPLE! there are only 3 .dart file, one for View(UI), one for Controller(GetX) and one for the separated state(better management for state)