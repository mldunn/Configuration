# Configuration Project

## Overview

Load an XML file and persist to Core Data in a dynamic fashion, minimizing schema changes


### XML Schema

```
<root>
<section1>
<itemA type="">value</itemA>
<itemB>value</itemB>
</section1>
</root>
```

There can have multiple sections with multiple items in each section, node names are dynamic.  A type attribute is included on value items to determine the appropriate data type for the value

### Data Model

The data model consists of generic entities representing XML nodes

    Section
    - id
    - name
    - position'
    
    - items (1-M to SectionItem)
    
    SectionItem
     - id
     - key
     - dataType
     - stringValue
     - numValue
     - boolValue
     
     - section (inverse relationship)
     
Section represents a parent node for items consisting of a name and the position within the xml structure

SectionItem represents a value item that can be of one of three types: text, bool, or int.  The type value is stored in the appropriate  attribute.  


### UI

The app consist of a Home screen where there is a link to Edit Settings, tapping Edit Settings will bring up a form consisting of the values arranged by section with corresponding controls for the data type. 



