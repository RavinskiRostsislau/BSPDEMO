///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ДобавитьОбъектВФильтрРазрешенныхОбъектов(Знач Объект, Знач Получатель) Экспорт
	
	Если Не ОбъектЕстьВРегистре(Объект, Получатель) Тогда
		
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("УзелИнформационнойБазы", Получатель);
		СтруктураЗаписи.Вставить("Ссылка", Объект);
		
		ДобавитьЗапись(СтруктураЗаписи, Истина);
	КонецЕсли;
	
КонецПроцедуры

Функция ОбъектЕстьВРегистре(Объект, УзелИнформационнойБазы) Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ 1
	|ИЗ
	|	РегистрСведений.ДанныеОбъектовДляРегистрацииВОбменах КАК ДанныеОбъектовДляРегистрацииВОбменах
	|ГДЕ
	|	  ДанныеОбъектовДляРегистрацииВОбменах.УзелИнформационнойБазы           = &УзелИнформационнойБазы
	|	И ДанныеОбъектовДляРегистрацииВОбменах.Ссылка = &Объект
	|";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзелИнформационнойБазы);
	Запрос.УстановитьПараметр("Объект", Объект);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Не Запрос.Выполнить().Пустой();
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура добавляет запись в регистр по переданным значениям структуры.
Процедура ДобавитьЗапись(СтруктураЗаписи, Загрузка = Ложь)
	
	ОбменДаннымиСлужебный.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "ДанныеОбъектовДляРегистрацииВОбменах", Загрузка);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли