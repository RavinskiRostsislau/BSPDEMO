///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает объекты метаданных с предопределенными элементами.
//
// Возвращаемое значение:
//   ФиксированныйМассив Из Строка - массив, содержащий полные имена объектов метаданных.
//
Функция ОбъектыМетаданныхСПредопределеннымиЭлементами() Экспорт
	
	Кэш = Новый Массив();
	
	Для Каждого ОбъектМетаданных Из Метаданные.Справочники Цикл
		Кэш.Добавить(ОбъектМетаданных.ПолноеИмя());
	КонецЦикла;
	
	Для Каждого ОбъектМетаданных Из Метаданные.ПланыСчетов Цикл
		Кэш.Добавить(ОбъектМетаданных.ПолноеИмя());
	КонецЦикла;
	
	Для Каждого ОбъектМетаданных Из Метаданные.ПланыВидовХарактеристик Цикл
		Кэш.Добавить(ОбъектМетаданных.ПолноеИмя());
	КонецЦикла;
	
	Для Каждого ОбъектМетаданных Из Метаданные.ПланыВидовРасчета Цикл
		Кэш.Добавить(ОбъектМетаданных.ПолноеИмя());
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(Кэш);
	
КонецФункции

#КонецОбласти
