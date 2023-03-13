public with sharing class Data {

	public class AccountBuilder {

		public Account account { get; set; }

		public AccountBuilder newAccount () {

			this.account = new Account();
			return this;
		}

		public AccountBuilder setDescription (Object description) {

			this.account.Description = String.valueOf(description);
			return this;
		}

		public AccountBuilder setName (Object name) {

			this.account.Name = String.valueOf(name);
			return this;
		}

		public AccountBuilder setFirstName (Object firstname) {
			this.account.FirstName = String.valueOf(firstname);
			return this;
		}

		public AccountBuilder setLastName (Object lastname) {

			this.account.LastName = String.valueOf(lastname);
			return this;
		}

		public AccountBuilder setParentId (Id parentId) {

			this.account.ParentId = parentId;
			return this;
		}

		public AccountBuilder setPhone (Object phone) {

			this.account.Phone = String.valueOf(phone);
			return this;
		}

		public AccountBuilder setPersonMailingCity (Object personalMailingCity) {
			this.account.PersonMailingCity = String.valueOf(personalMailingCity);
			return this;
		}

		public AccountBuilder setPersonMailingStreet (Object personalMailingStreet) {
			this.account.PersonmailingStreet = String.valueOf(personalMailingStreet);
			return this;
		}

		public AccountBuilder setPersonMailingState (Object personalMailingState) {
			this.account.PersonMailingState = String.valueOf(personalMailingState);
			return this;
		}

		public AccountBuilder setPersonMailingStateCode (Object personalMailingStateCode) {
			this.account.PersonMailingStateCode = String.valueOf(personalMailingStateCode);
			return this;
		}

		public AccountBuilder setPersonmailingCountry (Object personalMailingCountry) {
			this.account.Personmailingcountry = String.valueOf(personalMailingCountry);
			return this;
		}

		public AccountBuilder setMailingStreet1 (Object mailingStreet1) {
			this.account.Mailing_Street_1__c = String.valueOf(mailingStreet1);
			return this;
		}

		public AccountBuilder setMailingStreet2 (Object mailingStreet2) {
			this.account.Mailing_Street_1__c = String.valueOf(mailingStreet2);
			return this;
		}

		public AccountBuilder newAccountPersonForTest(){
			this.account.FirstName= 'Dan';
			this.account.LastName='Smith';
			this.account.PersonMobilePhone = '1111111';
			this.account.Phone = '2222222';
			this.account.PersonEmail = 'test@test.com';
			return this;
		}

		public AccountBuilder setConsentToText(object consentToText){
			this.account.Consent_To_Text__c = String.valueOf(consentToText);
			return this;
		}

		public AccountBuilder setFax(object setFax){
			this.account.Fax = String.valueOf(setFax);
			return this;
		}

		public AccountBuilder setOfficeContactEmail(object officeContactEmail){
			this.account.Office_Contact_Email__c = String.valueOf(officeContactEmail);
			return this;
		}

		public AccountBuilder setOfficeContactName(object officeContactName){
			this.account.Office_Contact_Name__c = String.valueOf(officeContactName);
			return this;
		}

		public AccountBuilder setSMSOptOut(Boolean smsOptOut){
			this.account.smagicinteract__SMSOptOut__pc = smsOptOut;
			return this;
		}

		public AccountBuilder setHCSPatientId(object hcsPatientId){
			this.account.HCS_Patient_Id__c = String.valueOf(hcsPatientId);
			return this;
		}

		public AccountBuilder setHCPEmail(object hcpEmail){
			this.account.HCP_Email__c = String.valueOf(hcpEmail);
			return this;
		}

		public AccountBuilder setNPINumber(object npiNumber){
			this.account.cnf__NPI_Number__c = String.valueOf(npiNumber);
			return this;
		}

		public AccountBuilder doInsert () {
            insert this.account;
			return this;
		}
	}

	public class ContactBuilder{
		public Contact con { get; set; }

		public ContactBuilder newContact() {
			this.con = new Contact();
			return this;
		}

		public ContactBuilder setFirstName(object firstName){
			this.con.FirstName = String.valueOf(firstName);
			return this;
		}

		public ContactBuilder setLastName(object lastName){
			this.con.LastName = String.valueOf(lastName);
			return this;
		}

		public ContactBuilder setMobilePhone(object mobilePhone){
			this.con.MobilePhone = String.valueOf(mobilePhone);
			return this;
		}

		public ContactBuilder doInsert () {
            insert this.con;
			return this;
		}
	}

	public class CaseBuilder{
		public Case cs { get; set; }

		public CaseBuilder newCase () {
			this.cs = new Case();
			return this;
		}

		public CaseBuilder setAccountId(Id accountId){
			this.cs.AccountId = accountId;
			return this;
		}

		public CaseBuilder setRecordTypeId(Id recordTypeId){
			this.cs.RecordTypeId = recordTypeId;
			return this;
		}

		public CaseBuilder setPatientSMSOptOut(Boolean patientSMSOptOut){
			this.cs.Patient_SMS_Opt_Out__c = patientSMSOptOut;
			return this;
		}

		public CaseBuilder setAssignedResourcePhone(Object assignedResourcePhone){
			this.cs.Assigned_Resource_Phone__c = String.valueOf(assignedResourcePhone);
			return this;
		}

		public CaseBuilder setReminderTextToPatient(Boolean reminderTextToPatient){
			this.cs.Reminder_Text_to_Patient__c = reminderTextToPatient;
			return this;
		}

		public CaseBuilder setStatus(Object status){
			this.cs.Status = String.valueOf(status);
			return this;
		}

		public CaseBuilder setReferringProvider(Id referringProviderId){
			this.cs.Referring_Provider__c = referringProviderId;
			return this;
		}

		public CaseBuilder setCancellationReason(object cancellationReason){
			this.cs.Cancellation_Reason__c = String.valueOf(cancellationReason);
			return this;
		}

		public CaseBuilder setAppointmentDateTime(object appointmetDateTime){
			this.cs.Appointment_Date_Time__c = DateTime.valueOf(appointmetDateTime);
			return this;
		}

		public CaseBuilder setConfirmSRFForPatient(Boolean confirmSRFForPatient){
			this.cs.Confirm_SRF_for_Patient__c = confirmSRFForPatient;
			return this;
		}

		public CaseBuilder setAppointmentConfirmationStatus(object apptConfirmationStatus){
			this.cs.Appointment_Confirmation_Status__c = String.valueOf(apptConfirmationStatus);
			return this;
		}

		public CaseBuilder setAssignedResourceEmail(object assignedResourceEmail){
			this.cs.Assigned_Resource_Email_email__c = String.valueOf(assignedResourceEmail);
			return this;
		}

		public CaseBuilder setAppointmentServices(object apptServices){
			this.cs.Appointment_Services__c = String.valueOf(apptServices);
			return this;
		}

		public CaseBuilder setReminderTextToClinician(Boolean reminderTextToClinician){
			this.cs.Reminder_Text_to_Clinician__c = reminderTextToClinician;
			return this;
		}

		public CaseBuilder setReminderEmailToClinicalStaff(Boolean reminderEmailToClinicalStaff){
			this.cs.Reminder_Email_to_Clinical_Staff__c = reminderEmailToClinicalStaff;
			return this;
		}

		public CaseBuilder setConfirmAttendanceForPatient(Boolean confirmAttendanceForPatient){
			this.cs.Confirm_Attendance_for_Patient_MA__c = confirmAttendanceForPatient;
			return this;
		}

		public CaseBuilder setAppointmentId(object appId){
			this.cs.Appointment_Id__c = String.valueOf(appId);
			return this;
		}

		public CaseBuilder setHCSAppointmentType(object hcsApptType){
			this.cs.HCS_Appointment_Type_Inbound__c = String.valueOf(hcsApptType);
			return this;
		}

		public CaseBuilder setAssignedResource(Id resourceId){
			this.cs.Assigned_Resource__c = resourceId;
			return this;
		}

		public CaseBuilder setGilenyaApptEmail(object gilenyaEmail){
			this.cs.GILENYA_Appt_Type_Email__c = String.valueOf(gilenyaEmail);
			return this;
		}

		public CaseBuilder setGilenyaCbcEmail(object gilenyaCbcEmail){
			this.cs.GILENYA_CBC_Email__c = String.valueOf(gilenyaCbcEmail);
			return this;
		}

		public CaseBuilder setCreatedViaEmailParser(Boolean isCreatedByEmailParser){
			this.cs.Created_via_Email_Parser__c = isCreatedByEmailParser;
			return this;
		}

		public CaseBuilder setAssignedClinician(Id clincianId){
			this.cs.Assigned_Clinician__c = clincianId;
			return this;
		}

		public CaseBuilder doInsert () {
            insert this.cs;
			return this;
		}
	}

	public class RegionBuilder{
		public sked__Region__c region { get; set; }

		public RegionBuilder newRegion(){
			this.region = new sked__Region__c();
			return this;
		}

		public RegionBuilder setTimeZone(object regionTimeZone){
			this.region.sked__Timezone__c  = String.valueOf(regionTimeZone);
			return this;
		}

		public RegionBuilder setDescription(object description){
			this.region.sked__Description__c  = String.valueOf(description);
			return this;
		}

		public RegionBuilder doInsert(){
			insert this.region;
			return this;
		}
	}

	public class JobBuilder{
		public sked__Job__c job { get; set; }

		public JobBuilder newJob(){
			this.job = new sked__Job__c();
			return this;
		}

		public JobBuilder setDuration(Decimal duration){
			this.job.sked__Duration__c  = duration;
			return this;
		}

		public JobBuilder setRegion(Id regionId){
			this.job.sked__Region__c  = regionId;
			return this;
		}

		public JobBuilder setCase(Id caseId){
			this.job.Case__c  = caseId;
			return this;
		}

		public JobBuilder doInsert(){
			insert this.job;
			return this;
		}
	}

	public class SMSBuilder{
		public smagicinteract__smsMagic__c sms { get; set; }

		public SMSBuilder newSms(){
			this.sms = new smagicinteract__smsMagic__c();
			return this;
		}

		public SMSBuilder setCase(Id caseId){
			this.sms.smagicinteract__Case__c = caseId;
			return this;
		}

		public SMSBuilder setDirection(object direction){
			this.sms.smagicinteract__Direction__c = String.valueOf(direction);
			return this;
		}

		public SMSBuilder setPhone(object phone){
			this.sms.smagicinteract__PhoneNumber__c = String.valueOf(phone);
			return this;
		}

		public SMSBuilder setSmsText(object smsText){
			this.sms.smagicinteract__SMSText__c = String.valueOf(smsText);
			return this;
		}

		public SMSBuilder setSender(object sender){
			this.sms.smagicinteract__SenderId__c = String.valueOf(sender);
			return this;
		}

		public SMSBuilder setExternalField(object externalField){
			this.sms.smagicinteract__external_field__c = String.valueOf(externalField);
			return this;
		}

		public SMSBuilder setConverseAppAction(Id converseAppActionId){
			this.sms.smagicinteract__Converse_App_Action__c = converseAppActionId;
			return this;
		}
		public SMSBuilder setPreviousMessage(Id smsHistoryId){
			this.sms.smagicinteract__Previous_Message__c = smsHistoryId;
			return this;
		}

		public SMSBuilder doInsert(){
			insert this.sms;
			return this;
		}
		
	}

	public class ConverseAppBuilder{
		public smagicinteract__Converse_App__c converseApp { get; set; }

		public ConverseAppBuilder newConverseApp(){
			this.converseApp = new smagicinteract__Converse_App__c();
			return this;
		}

		public ConverseAppBuilder setName(object name){
			this.converseApp.Name = String.valueOf(name);
			return this;
		}

		public ConverseAppBuilder doInsert(){
			insert this.converseApp;
			return this;
		}
		
	}

	public class ConverseAppActionBuilder{
		public smagicinteract__Converse_App_Action__c converseAppAction { get; set; }

		public ConverseAppActionBuilder newConverseAppAction(){
			this.converseAppAction = new smagicinteract__Converse_App_Action__c();
			return this;
		}

		public ConverseAppActionBuilder setName(object name){
			this.converseAppAction.Name = String.valueOf(name);
			return this;
		}

		public ConverseAppActionBuilder setConverseApp(Id converseAppId){
			this.converseAppAction.smagicinteract__Converse_App__c = converseAppId;
			return this;
		}

		public ConverseAppActionBuilder setMobilePhoneField(object mobilePhone){
			this.converseAppAction.smagicinteract__Mobile_Phone_Field__c = String.valueOf(mobilePhone);
			return this;
		}

		public ConverseAppActionBuilder doInsert(){
			insert this.converseAppAction;
			return this;
		}
		
	}

	public class ResourceBuilder{
		public sked__Resource__c resource { get; set; }

		public ResourceBuilder newResource(){
			this.resource = new sked__Resource__c();
			return this;
		}

		public ResourceBuilder setAccount(Id accountId){
			this.resource.Account__c = accountId;
			return this;
		}

		public ResourceBuilder doInsert(){
			insert this.resource;
			return this;
		}
	}

	public class AvailabilityBuilder{
		public sked__Availability__c availability { get; set; }

		public AvailabilityBuilder newAvailability(){
			this.availability = new sked__Availability__c();
			return this;
		}

		public AvailabilityBuilder setIsAvailable(Boolean isAvailable){
			this.availability.sked__Is_Available__c = isAvailable;
			return this;
		}

		public AvailabilityBuilder setType(object type){
			this.availability.sked__Type__c = String.valueOf(type);
			return this;
		}

		public AvailabilityBuilder setResource(Id resourceId){
			this.availability.sked__Resource__c = resourceId;
			return this;
		}

		public AvailabilityBuilder setStart(object start){
			this.availability.sked__Start__c = DateTime.valueOf(start);
			return this;
		}

		public AvailabilityBuilder setFinish(object finish){
			this.availability.sked__Finish__c = DateTime.valueOf(finish);
			return this;
		}

		public AvailabilityBuilder doInsert(){
			insert this.availability;
			return this;
		}
	}

	public class ConsentBuilder{
		public smagicinteract__Consent__c consent { get; set; }

		public ConsentBuilder newConsent(){
			this.consent = new smagicinteract__Consent__c();
			return this;
		}

		public ConsentBuilder setContact(Id contactId){
			this.consent.smagicinteract__Contact__c = contactId;
			return this;
		}

		public ConsentBuilder doInsert(){
			insert this.consent;
			return this;
		}
	}

	public class ResourceTagBuilder{
		public sked__Resource_Tag__c resourceTag { get; set; }

		public ResourceTagBuilder newResourceTag(){
			this.resourceTag = new sked__Resource_Tag__c();
			return this;
		}

		public ResourceTagBuilder setResource(Id resourceId){
			this.resourceTag.sked__Resource__c = resourceId;
			return this;
		}

		public ResourceTagBuilder setTag(Id tagId){
			this.resourceTag.sked__Tag__c = tagId;
			return this;
		}

		public ResourceTagBuilder doInsert(){
			insert this.resourceTag;
			return this;
		}
	}

	public class TagBuilder{
		public sked__Tag__c tag { get; set; }

		public TagBuilder newTag(){
			this.tag = new sked__Tag__c();
			return this;
		}

		public TagBuilder setName(object name){
			this.tag.Name = String.valueOf(name);
			return this;
		}

		public TagBuilder setClassification(object classification){
			this.tag.sked__Classification__c = String.valueOf(classification);
			return this;
		}

		public TagBuilder setType(object type){
			this.tag.sked__Type__c = String.valueOf(type);
			return this;
		}

		public TagBuilder setUniqueKey(object uniquekey){
			this.tag.sked__UniqueKey__c = String.valueOf(uniquekey);
			return this;
		}

		public TagBuilder doInsert(){
			insert this.tag;
			return this;
		}
	}
}