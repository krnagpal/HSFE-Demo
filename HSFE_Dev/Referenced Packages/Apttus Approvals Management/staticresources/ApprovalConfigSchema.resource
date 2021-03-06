<?xml version="1.0" encoding="UTF-8"?>
<!-- edited with XMLSpy v2011 (x64) (http://www.altova.com) by Nathan Krishnan (private) -->
<!--
 Copyright 2009-2011 Apttus Inc. All Rights Reserved.    
$Id: //Apttus/Develop/dev/schemas/ComplyConfig.xsd $
$DateTime: 2010/05/18 19:02:26 $
This software is the proprietary information of Apttus, Inc.
Use is subject to license terms.

Author : Nathan Krishnan
    
Version: $Revision: #4 $

Description:
    Defines schema ApprovalsConfig
-->
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="unqualified" attributeFormDefault="unqualified">
	<xs:element name="ApprovalConfig" type="ApprovalConfigType">
		<xs:annotation>
			<xs:documentation>Approval Configuration</xs:documentation>
		</xs:annotation>
	</xs:element>
	<!-- comply config -->
	<xs:complexType name="ApprovalConfigType">
		<xs:sequence>
			<xs:element name="DealSpec" type="DealSpecType" minOccurs="0">
				<xs:annotation>
					<xs:documentation>The deal approval spec</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="OpportunitySpec" type="OpportunitySpecType" minOccurs="0">
				<xs:annotation>
					<xs:documentation>The opportunity approval spec</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="AgreementSpec" type="AgreementSpecType" minOccurs="0">
				<xs:annotation>
					<xs:documentation>The agreement approval spec</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="AgreementTermExSpec" type="AgreementTermExSpecType" minOccurs="0">
				<xs:annotation>
					<xs:documentation>The agreement termex approval spec</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="QuoteSpec" type="QuoteSpecType" minOccurs="0">
				<xs:annotation>
					<xs:documentation>The quote approval spec</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="QuoteLineItemSpec" type="QuoteSpecType" minOccurs="0">
				<xs:annotation>
					<xs:documentation>The quote lineitem approval spec</xs:documentation>
				</xs:annotation>
			</xs:element>
		</xs:sequence>
	</xs:complexType>
	<!-- email template spec -->
	<xs:complexType name="EmailTemplateType">
		<xs:sequence>
			<xs:element name="AssignmentEmailTemplate" type="xs:string">
				<xs:annotation>
					<xs:documentation>The assignment email template.</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="ReassignmentEmailTemplate" type="xs:string">
				<xs:annotation>
					<xs:documentation>The reassignment email template.</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="EscalationEmailTemplate" type="xs:string">
				<xs:annotation>
					<xs:documentation>The escalation email template.</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="NotifyOnlyEmailTemplate" type="xs:string">
				<xs:annotation>
					<xs:documentation>The notify only email template.</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="CancellationEmailTemplate" type="xs:string">
				<xs:annotation>
					<xs:documentation>The cancellation email template.</xs:documentation>
				</xs:annotation>
			</xs:element>
		</xs:sequence>
	</xs:complexType>
	<!-- deal spec -->
	<xs:complexType name="DealSpecType">
		<xs:sequence>
			<xs:element name="EmailTemplates" type="EmailTemplateType">
				<xs:annotation>
					<xs:documentation>The deal approval email templates</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="BackupAdminUser" type="xs:string">
				<xs:annotation>
					<xs:documentation>The deal approval backup admin user</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="ApprovalContextType" type="xs:string">
				<xs:annotation>
					<xs:documentation>The approval context type associated with the process for the object</xs:documentation>
				</xs:annotation>
			</xs:element>
		</xs:sequence>
	</xs:complexType>
	<!-- opportunity spec -->
	<xs:complexType name="OpportunitySpecType">
		<xs:sequence>
			<xs:element name="EmailTemplates" type="EmailTemplateType">
				<xs:annotation>
					<xs:documentation>The opportunity approval email templates</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="BackupAdminUser" type="xs:string">
				<xs:annotation>
					<xs:documentation>The opportunity approval backup admin user</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="ApprovalContextType" type="xs:string">
				<xs:annotation>
					<xs:documentation>The approval context type associated with the process for the object</xs:documentation>
				</xs:annotation>
			</xs:element>
		</xs:sequence>
	</xs:complexType>
	<!-- agreement spec -->
	<xs:complexType name="AgreementSpecType">
		<xs:sequence>
			<xs:element name="EmailTemplates" type="EmailTemplateType">
				<xs:annotation>
					<xs:documentation>The agreement approval email templates</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="BackupAdminUser" type="xs:string">
				<xs:annotation>
					<xs:documentation>The agreement approval backup admin user</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="ApprovalContextType" type="xs:string">
				<xs:annotation>
					<xs:documentation>The approval context type associated with the process for the object</xs:documentation>
				</xs:annotation>
			</xs:element>
		</xs:sequence>
	</xs:complexType>
	<!-- agreement termex spec -->
	<xs:complexType name="AgreementTermExSpecType">
		<xs:sequence>
			<xs:element name="EmailTemplates" type="EmailTemplateType">
				<xs:annotation>
					<xs:documentation>The agreement termex approval email templates</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="BackupAdminUser" type="xs:string">
				<xs:annotation>
					<xs:documentation>The agreement termex approval backup admin user</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="ApprovalContextType" type="xs:string">
				<xs:annotation>
					<xs:documentation>The approval context type associated with the process for the object</xs:documentation>
				</xs:annotation>
			</xs:element>
		</xs:sequence>
	</xs:complexType>
	<!-- quote spec -->
	<xs:complexType name="QuoteSpecType">
		<xs:sequence>
			<xs:element name="EmailTemplates" type="EmailTemplateType">
				<xs:annotation>
					<xs:documentation>The quote approval email templates</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="BackupAdminUser" type="xs:string">
				<xs:annotation>
					<xs:documentation>The quote approval backup admin user</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="ApprovalContextType" type="xs:string">
				<xs:annotation>
					<xs:documentation>The approval context type associated with the process for the object</xs:documentation>
				</xs:annotation>
			</xs:element>
		</xs:sequence>
	</xs:complexType>
	<!-- quote lineitem spec -->
	<xs:complexType name="QuoteLineItemSpecType">
		<xs:sequence>
			<xs:element name="EmailTemplates" type="EmailTemplateType">
				<xs:annotation>
					<xs:documentation>The quote line item approval email templates</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="BackupAdminUser" type="xs:string">
				<xs:annotation>
					<xs:documentation>The quote line item approval backup admin user</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="ApprovalContextType" type="xs:string">
				<xs:annotation>
					<xs:documentation>The approval context type associated with the process for the object</xs:documentation>
				</xs:annotation>
			</xs:element>
		</xs:sequence>
	</xs:complexType>
</xs:schema>
