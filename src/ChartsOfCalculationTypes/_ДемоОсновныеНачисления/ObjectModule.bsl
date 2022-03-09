///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	БлокировкаДанных = Новый БлокировкаДанных;
	Для Каждого ПланВидовРасчета Из Метаданные.ПланыВидовРасчета Цикл 
		БлокировкаДанных.Добавить(ПланВидовРасчета.ПолноеИмя());
	КонецЦикла;
	БлокировкаДанных.Заблокировать();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	_ДемоОсновныеНачисления.Ссылка
	|ИЗ
	|	ПланВидовРасчета._ДемоОсновныеНачисления КАК _ДемоОсновныеНачисления
	|ГДЕ
	|	_ДемоОсновныеНачисления.БазовыеВидыРасчета.ВидРасчета = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	ПодчиненныеВидыРасчета = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	Для Каждого ПодчиненныйСсылка Из ПодчиненныеВидыРасчета Цикл
		ПодчиненныйОбъект = ПодчиненныйСсылка.ПолучитьОбъект();
		Найденные = ПодчиненныйОбъект.БазовыеВидыРасчета.НайтиСтроки(Новый Структура("ВидРасчета", Ссылка));
		Для Каждого СтрокаТаблицы Из Найденные Цикл
			ПодчиненныйОбъект.БазовыеВидыРасчета.Удалить(СтрокаТаблицы);
		КонецЦикла;
		ПодчиненныйОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли