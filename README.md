# 🏷️TagClouds
"Gradientest" tags I've ever made

## Использовано:

- UIKit
- Верстка кодом + SnapKit + xib
- **Alamofire**
- **Codable** для парсинга JSON

## Сделано:

- Получить данные о коктейлях с публичного API 
- Спарcить JSON ответ используя Codable
- Вывести “облако тегов” c названиями полученных коктейлей :
    - выводим их в строку, если новый элемент не умещается, переносим на новую строку
    - По клику на тег, он окрашивается в краснофиолетовый градиент
- Внизу экрана текстфилд с тенью и округленными краями
- По клику на текстфилд он прилипает к верхнему краю клавиатуры и расширяется до границ экрана, округление углов убирается
- По клику на пустое место экрана клавиатура исчезает, текстфилд возвращается к своему изначальному состоянию
- При вводе слова, если оно встречается в одном из тегов, то окрашиваем данный тег

## Demo:
https://user-images.githubusercontent.com/49292756/161389850-a6f0f4bf-faa3-4267-8651-9a37715fee21.mp4


