///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// См. ОбщегоНазначенияКлиентПереопределяемый.ПередНачаломРаботыСистемы
// 
// Параметры:
//	Параметры - См. ОбщегоНазначенияКлиентПереопределяемый.ПередНачаломРаботыСистемы.Параметры
//
Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыКлиента.Свойство("ОбластьДанныхЗаблокирована") Тогда
		Параметры.Отказ = Истина;
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения(
			"ПоказатьПредупреждениеИПродолжить",
			СтандартныеПодсистемыКлиент,
			ПараметрыКлиента.ОбластьДанныхЗаблокирована);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти