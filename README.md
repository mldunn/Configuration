# Configuration

## Overview

Load an XML file and persist to Core Data in a dynamic fashion, minimizing schema changes, xml is model as

<root>
<section1>
<itemA>value</itemA>
<itemB>value</itemB>
</section1>
</root>

you can have multiple sections with multiple items in each section, node names are dynamic

### Data Model

The data model consists of generic entities representing XML Nodes, 

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

SectionItem represents a value item that can be of one of three types: text, bool, or int.  The type value is stored in the approprate attribute.

