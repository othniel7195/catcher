# catcher

Catcher Exception Plugin

## Getting Started

#### Example： 具体使用参考example/main.dart

```dart
void main() {
  CatcherError(
      runAppFunction: () {
        runApp(const MyApp());
      });
}
```



#### Install:

pubspec.yaml

```yaml
dependencies:
	catcher:
		git:
			url: 'git@gitlab.shuinfo.com:shuinfo/app/flutter/catcher.git'
			ref: '0.1'

```

​	

​	
