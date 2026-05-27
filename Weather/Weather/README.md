# Weather

Мобильное iOS-приложение для просмотра текущей погоды, почасового прогноза и прогноза на несколько дней с рекомендацией одежды под погодные условия.

## Возможности

- Определение текущей геолокации пользователя
- Загрузка текущей погоды по координатам
- Почасовой прогноз на ближайшие 24 часа
- Прогноз на несколько следующих дней
- Подбор одежды по температуре и погодным условиям
- Сохранение городов в локальный список
- Добавление и удаление городов
- Отображение сохранённых городов в кастомном tab bar
- Поддержка дневного и ночного оформления погодного экрана

## Стек технологий

- `Swift`
- `UIKit`
- `SwiftUI`
- `CoreLocation`
- `CoreData`
- `URLSession`
- `async/await`
- `SnapKit`

## Используемые API

- `Yandex Weather API` — получение прогноза погоды
- `DaData API` — прямое и обратное геокодирование
- `CLGeocoder` — резервное геокодирование средствами iOS

## Структура проекта

- [View](/Users/ruslanahmetsafin/Documents/Swift/Weather/Weather/View) — экраны, tab bar, SwiftUI-представления
- [ViewModel](/Users/ruslanahmetsafin/Documents/Swift/Weather/Weather/ViewModel) — загрузка данных, сохранение городов, рекомендации одежды
- [Model](/Users/ruslanahmetsafin/Documents/Swift/Weather/Weather/Model) — модели ответа API, погодные модели, алгоритмы
- [Errors](/Users/ruslanahmetsafin/Documents/Swift/Weather/Weather/Errors) — типы ошибок приложения
- [SecretInformations](/Users/ruslanahmetsafin/Documents/Swift/Weather/Weather/SecretInformations) — ключи и конфиденциальные данные

## Ключевые экраны

- Главный экран с текущей погодой
- Почасовой прогноз
- Прогноз на следующие дни
- Список сохранённых городов

## Как запустить проект

1. Откройте [Weather.xcodeproj](/Users/ruslanahmetsafin/Documents/Swift/Weather/Weather/Weather.xcodeproj).
2. Убедитесь, что в папке [SecretInformations](/Users/ruslanahmetsafin/Documents/Swift/Weather/Weather/SecretInformations) указаны рабочие ключи:
   - `Yandex Weather API`
   - `DaData API`
3. Выберите симулятор или устройство.
4. Запустите проект через Xcode.

## Где находятся ключи

- [SecretsWeather.swift](/Users/ruslanahmetsafin/Documents/Swift/Weather/Weather/SecretInformations/SecretsWeather.swift)
- [SecretLocation.swift](/Users/ruslanahmetsafin/Documents/Swift/Weather/Weather/SecretInformations/SecretLocation.swift)

## Особенности реализации

- Прогноз по текущей локации строится через `CoreLocation`
- Название города определяется через `DaData` и fallback на `CLGeocoder`
- Сохранённые города хранятся в `CoreData`
- Для рекомендаций одежды используется собственный алгоритм на основе температуры и погодных условий
- Фон экрана подбирается по состоянию погоды и времени суток

## Возможные улучшения

- Экран настроек персонажа
- Кэширование полного прогноза по сохранённым городам
- Улучшение анимаций и визуального оформления
- Поддержка переключения единиц измерения

## Автор

Проект разработан в рамках курсовой работы по созданию iOS-приложения прогноза погоды.
