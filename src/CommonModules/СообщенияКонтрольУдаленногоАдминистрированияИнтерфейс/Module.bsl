///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает текущую (используемую вызывающим кодом) версию интерфейса сообщений.
// @skip-warning ПустойМетод - особенность реализации.
// Возвращаемое значение:
//	Строка - 
Функция Версия() Экспорт
КонецФункции

// Возвращает пространство имен текущей (используемой вызывающим кодом) версии интерфейса сообщений.
// @skip-warning ПустойМетод - особенность реализации.
// Возвращаемое значение:
//	Строка - 
Функция Пакет() Экспорт
КонецФункции

// Возвращает название программного интерфейса сообщений.
// @skip-warning ПустойМетод - особенность реализации.
// Возвращаемое значение:
//	Строка - 
Функция ПрограммныйИнтерфейс() Экспорт
КонецФункции

// Выполняет регистрацию обработчиков сообщений в качестве обработчиков каналов обмена сообщениями.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  МассивОбработчиков - Массив - обработчики сообщений.
//
Процедура ОбработчикиКаналовСообщений(Знач МассивОбработчиков) Экспорт
КонецПроцедуры

// Выполняет регистрацию обработчиков трансляции сообщений.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  МассивОбработчиков - Массив - обработчики сообщений.
//
Процедура ОбработчикиТрансляцииСообщений(Знач МассивОбработчиков) Экспорт
КонецПроцедуры

// Возвращает тип сообщения {http://www.1c.ru/SaaS/RemoteAdministration/Control/a.b.c.d}ApplicationPrepared.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипЗначенияXDTO, ТипОбъектаXDTO - тип сообщения.
//
Функция СообщениеОбластьДанныхПодготовлена(Знач ИспользуемыйПакет = Неопределено) Экспорт
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/RemoteAdministration/Control/a.b.c.d}ApplicationDeleted.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипЗначенияXDTO, ТипОбъектаXDTO - тип сообщения.
//
Функция СообщениеОбластьДанныхУдалена(Знач ИспользуемыйПакет = Неопределено) Экспорт
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/RemoteAdministration/Control/a.b.c.d}ApplicationPrepareFailed.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипЗначенияXDTO, ТипОбъектаXDTO - тип сообщения.
//
Функция СообщениеОшибкаПодготовкиОбластиДанных(Знач ИспользуемыйПакет = Неопределено) Экспорт
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/RemoteAdministration/Control/a.b.c.d}ApplicationPrepareFailedConversionRequired
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипЗначенияXDTO, ТипОбъектаXDTO - тип сообщения.
//
Функция СообщениеОшибкаПодготовкиОбластиДанныхТребуетсяКонвертация(Знач ИспользуемыйПакет = Неопределено) Экспорт
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/RemoteAdministration/Control/a.b.c.d}ApplicationDeleteFailed.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипЗначенияXDTO, ТипОбъектаXDTO - тип сообщения.
//
Функция СообщениеОшибкаУдаленияОбластиДанных(Знач ИспользуемыйПакет = Неопределено) Экспорт
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/RemoteAdministration/Control/a.b.c.d}ApplicationReady.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипЗначенияXDTO, ТипОбъектаXDTO - тип сообщения.
//
Функция СообщениеОбластьДанныхГотоваКИспользованию(Знач ИспользуемыйПакет = Неопределено) Экспорт
КонецФункции

#КонецОбласти