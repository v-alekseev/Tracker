# Tracker
Приложение помогает пользователям формировать полезные привычки и контролировать их выполнение. UIKit, верстка полностью в коде. Отображение контента с помощью UICollectionView. Хранение данных в CoreData. Архитектура MVP и MVVM. Зависимости добавлены через CocoaPods. В приложении реализован экран онбординга при первом запуске.

## Сборка
### CocoaPods
В проект не добавлена директория pods. Поэтому перед запуском надо выполнить в директории проекта.
```
pod install
```
### Swiftgen
Для генерации файла с локалищзацией нужно из директории проекта выполнить команды.
```
cd swiftgenbin
swiftgen
```

## Стек
- Архитектура MVP и MVVM.
- Вёрстка кодом с Auto Layout. Дизайн в Figma.
- UICollectionView, UITabBarController, UINavigationController.
- Хранение данных в CoreData
- Зависимости добавлены через CocoaPods.
- Unit-тесты.

## Локализация
Для тестирования Английской локализации в проект добавлена схема запуска TrackerEn
## Screenshots
<img width="200" height="422" alt="main" src="https://github.com/v-alekseev/Tracker/blob/main/Tracker/Assets.xcassets/Screenshots/main_screen.imageset/2023-12-19_18-32-11.png"> <img width="200" height="422" alt="statistic" src="https://github.com/v-alekseev/Tracker/blob/main/Tracker/Assets.xcassets/Screenshots/statistic_screen.imageset/2023-12-19_18-32-33.png">
