# Record Lookup
A Record Lookup component which lets you to select records from a selected List View or via a Global Search.

## Problem
It is difficult to search for records when you have lots of them in your org and when you want the records to be filtered based on a certain condition. Everytime we cannot go to the code and add WHERE conditions. Categorizing and viewing the records based on certain condition becomes difficult.

## Solution(s)
Create a component which displays a list of List Views defined on the object and selecting a List View would display the records pertaining to that specific List View. For this we can use the List View APIs to get the List View details and then obtain the SOQL query behind it and execute the same to get the respective records.

## Usage
In order to use this VF Component, all you have to do is to just include the Component on the VF page:
```
<apex:page>
    <c:RecordLookup id="accLkp" sobject="Account" label="Account" componentWidth="70%" filterListClass="slds-select" recordsListClass="slds-select" load3rdPartyLib="true" onselect="onselect"/>
</apex:page>
```

This componenet has the following attributes

  `id`                  : This attribute is important when there are more than 1 component on the same page

  `sobject`             : API name of the Object from which we need the records

  `label`               : Label to be displayed alongside the component

  `defaultValue`        : Default value that needs to be displayed upon the initial load of the component

  `componentWidth`      : Width of the component

  `filterListClass`     : CSS class applied to the select tag displaying the List Views

  `recordsListClass`    : CSS class applied to the select tag displaying the Records

  `load3rdPartyLib`     : Determine whether to load 3rd party libraries or not

  `globalSearchFilter`  : WHERE Clause to be considered when doing a global search

  `onselect`            : The JavaScript function that will be invoked upon selecting a record

  `callback`            : The JavaScript function that will be invoked after rendering the records list

  `ns`                  : The NamespacePrefix(if available) that needs to used in order to access the Controller methods

## Demo
Check out this link if you want to see it live.


## Deployment
Use the below button to deploy this to your SF Org in a single click! 

## Licensing
Completely free! Use it at your own will.
