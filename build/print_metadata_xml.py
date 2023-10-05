#!/usr/bin/env python3
import re
import xml.etree.ElementTree as ET
from xml.etree.ElementTree import tostring

tree = ET.parse('metadata.xml')
tree = tree.getroot()
t = tostring(tree)
insert_slashes = t.decode("utf-8").replace("\"", "\\\"")
remove_returns = re.sub(r"\n", "", insert_slashes)
print(remove_returns)