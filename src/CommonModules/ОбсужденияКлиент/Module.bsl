///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Начать подключение системы взаимодействия.
//
// Параметры:
//   ОписаниеЗавершения - ОписаниеОповещения - оповещения, которые будет выполнено после закрытия формы подключения
// 											 с параметрами:
// 											 * Результат - Неопределено
// 											 * ДополнительныеПараметры - Неопределено
// 											                           - Структура.
//
Процедура ПоказатьПодключение(ОписаниеЗавершения = Неопределено) Экспорт
	ОбсужденияСлужебныйКлиент.ПоказатьПодключение(ОписаниеЗавершения);
КонецПроцедуры

// Начать отключение системы взаимодействия.
//
Процедура ПоказатьОтключение() Экспорт
	ОбсужденияСлужебныйКлиент.ПоказатьОтключение();
КонецПроцедуры

#КонецОбласти