///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	Если Не Параметры.Отказ И МиграцияПриложенийВызовСервера.НужноОткрытьФорму() Тогда
		Форма = ПолучитьФорму("Обработка.МиграцияПриложения.Форма.ПереходВСервис");
		Форма.ПриОткрытииФормы(Истина);
	КонецЕсли;
	
КонецПроцедуры

Функция ИмяФормыПереходаВСервис() Экспорт

	Возврат "ТехнологияСервиса.МиграцияПриложений.ФормаПереходВСервис";
	
КонецФункции

#КонецОбласти
