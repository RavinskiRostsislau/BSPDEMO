///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

// @strict-types

#Область ПрограммныйИнтерфейс

#Область КодыВозврата

// Возвращает код ошибки данных.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Возвращаемое значение:
//	Число - стандартный код возврата по имени метода.
//
Функция КодВозвратаОшибкаДанных() Экспорт
КонецФункции

// Возвращает код отказа авторизации.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Возвращаемое значение:
//	Число - стандартный код возврата по имени метода.
//
Функция КодВозвратаОтказАвторизации() Экспорт
КонецФункции

// Возвращает код внутренней ошибки.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Возвращаемое значение:
//	Число - стандартный код возврата по имени метода.
//
Функция КодВозвратаВнутренняяОшибка() Экспорт
КонецФункции

// Возвращает код выполнения с предупреждениями.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Возвращаемое значение:
//	Число - стандартный код возврата по имени метода.
//
Функция КодВозвратаВыполненоСПредупреждениями() Экспорт
КонецФункции

// Возвращает код успешного выполнения.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Возвращаемое значение:
//	Число - стандартный код возврата по имени метода.
//
Функция КодВозвратаВыполнено() Экспорт
КонецФункции

// Возвращает код отсутствия данных.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Возвращаемое значение:
//	Число - стандартный код возврата по имени метода.
//
Функция КодВозвратаНеНайдено() Экспорт
КонецФункции

#КонецОбласти

#Область ТипыФайлов

// Возвращает строку с типом файла JSON
// @skip-warning ПустойМетод - особенность реализации.
// 
// Возвращаемое значение:
//	Строка - "json"
//
Функция ТипJSON() Экспорт
КонецФункции

// Возвращает строку с типом файла XLSX
// @skip-warning ПустойМетод - особенность реализации.
// 
// Возвращаемое значение:
//	Строка - "xlsx"
//
Функция ТипXLSX() Экспорт
КонецФункции

// Возвращает строку с типом файла PDF
// @skip-warning ПустойМетод - особенность реализации.
// 
// Возвращаемое значение:
//	Строка - "pdf"
//
Функция ТипPDF() Экспорт
КонецФункции

#КонецОбласти

#КонецОбласти
