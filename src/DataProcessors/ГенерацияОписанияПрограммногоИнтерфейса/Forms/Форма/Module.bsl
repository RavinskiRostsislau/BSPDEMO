///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент ИЛИ МобильныйКлиент Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Для корректной работы необходим режим тонкого или толстого клиента.'"));
		Отказ = Истина;
		Возврат;
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДиалогСохранения = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ДиалогСохранения.МножественныйВыбор = Ложь;
	ДиалогСохранения.Фильтр = НСтр("ru = 'Описание программного интерфейса'") + "(*.html)|*.html";
	ОписаниеОповещения = Новый ОписаниеОповещения("ПутьКФайлуНачалоВыбораЗавершение", ЭтотОбъект);
	ФайловаяСистемаКлиент.ПоказатьДиалогВыбора(ОписаниеОповещения, ДиалогСохранения);
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогВыгрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДиалогВыбораКаталога = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбораКаталога.МножественныйВыбор = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("КаталогВыгрузкиНачалоВыбораЗавершение", ЭтотОбъект);
	ФайловаяСистемаКлиент.ПоказатьДиалогВыбора(ОписаниеОповещения, ДиалогВыбораКаталога);
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайлуОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ФайловаяСистемаКлиент.ОткрытьФайл(Объект.ПутьКФайлу);
КонецПроцедуры

&НаКлиенте
Процедура АнализируемыеПодсистемыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ФильтрПоСсылочнымМетаданным = Новый СписокЗначений;
	ФильтрПоСсылочнымМетаданным.Добавить("Подсистемы");
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("КоллекцииВыбираемыхОбъектовМетаданных", ФильтрПоСсылочнымМетаданным);
	ПараметрыВыбора.Вставить("ВыбранныеОбъектыМетаданных", Объект.АнализируемыеПодсистемы);
	
	Оповещение = Новый ОписаниеОповещения("АнализируемыеПодсистемыЗавершениеВыбора", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборОбъектовМетаданных", ПараметрыВыбора, , , , , Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура АнализируемыеПодсистемыЗавершениеВыбора(Результат, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(Результат) <> Тип("СписокЗначений") Тогда
		Возврат;
	КонецЕсли;
	
	Объект.АнализируемыеПодсистемы = Результат;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подготовить(Команда)
	Если Не ЗначениеЗаполнено(Объект.ПутьКФайлу) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Необходимо указать путь к файлу, в который будет сохранен результат.'"));
		Возврат;
	КонецЕсли;
	ПодготовитьНаСервере();
	
	Текст = НСтр("ru = 'Описание программного интерфейса подготовлено.'");
	ПоказатьПредупреждение(, Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокПредупреждений(Команда)
	Если Объект.ЛогСозданияОписания = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Сначала необходимо подготовить описание программного интерфейса.'"));
		Возврат;
	КонецЕсли;
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ЛогСозданияОписания", Объект.ЛогСозданияОписания);
	ОткрытьФорму(ПолноеИмяФормы("ПредупрежденияПриСозданииОписания"), ПараметрыОткрытия);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьНаСервере()
	МодульОбъекта = РеквизитФормыВЗначение("Объект");
	МодульОбъекта.СформироватьПрограммныйИнтерфейс();
	ЗначениеВРеквизитФормы(МодульОбъекта, "Объект");
КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ПутьКФайлу = Результат[0];
	// Для совместимости с Linux.
	Объект.ПутьКФайлу = СтрЗаменить(Объект.ПутьКФайлу, "\", "/");
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогВыгрузкиНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.КаталогВыгрузки = Результат[0];
	// Для совместимости с Linux.
	Объект.КаталогВыгрузки = СтрЗаменить(Объект.КаталогВыгрузки, "\", "/");
	
КонецПроцедуры

&НаКлиенте
Функция ПолноеИмяФормы(Имя)
	ЧастиИмени = СтрРазделить(ИмяФормы, ".");
	ЧастиИмени[3] = Имя;
	Возврат СтрСоединить(ЧастиИмени, ".");
КонецФункции

#КонецОбласти