global class RT_Util {

	static Boolean isSandbox;

	global static final Map<String, SObjectType> GD;
	static {
		GD = Schema.getGlobalDescribe();
	}

	global static final Set<DisplayType> STRING_TYPES;
	static {
		STRING_TYPES = new Set<DisplayType> {
			DisplayType.BASE64,
			DisplayType.EMAIL,
			DisplayType.MULTIPICKLIST,
			DisplayType.PHONE,
			DisplayType.PICKLIST,
			DisplayType.STRING,
			DisplayType.TEXTAREA,
			DisplayType.URL
		};
	}

	global static final Set<DisplayType> INTEGER_TYPES;
	static {
		INTEGER_TYPES = new Set<DisplayType> {
			DisplayType.INTEGER
		};
	}

	global static final Set<DisplayType> ID_TYPES;
	static {
		ID_TYPES = new Set<DisplayType> {
			DisplayType.ID,
			DisplayType.REFERENCE
		};
	}

	global static final Set<DisplayType> DOUBLE_TYPES;
	static {
		DOUBLE_TYPES = new Set<DisplayType> {
			DisplayType.CURRENCY,
			DisplayType.DOUBLE,
			DisplayType.PERCENT
		};
	}

	global static final Set<DisplayType> DATETIME_TYPES;
	static {
		DATETIME_TYPES = new Set<DisplayType> {
			DisplayType.DATETIME
		};
	}

	global static final Set<DisplayType> DATE_TYPES;
	static {
		DATE_TYPES = new Set<DisplayType> {
			DisplayType.DATE
		};
	}

	global static final Set<DisplayType> BOOLEAN_TYPES;
	static {
		BOOLEAN_TYPES = new Set<DisplayType> {
			DisplayType.BOOLEAN,
			DisplayType.COMBOBOX
		};
	}

	global static final String STR_OPT_NONE = '--None--',
	                           DEFAULT_DELIM = '~;~',
	                           LF = '\n',
	                           CRLF = '\r\n',
	                           CR = '\r';

	global static final Integer HASH_PRIME = 31;

	global static final Integer MAX_INTEGER;
	static {
		MAX_INTEGER = Math.pow(2, 31).intValue();
	}

	global static final Integer MIN_INTEGER = MAX_INTEGER + 1;

	/** Maximum number of collection entries in the VisualForce state */
	global static final Integer VF_COLLECTION_MAX = 1000;

	static Map<SObjectType, Map<String, DescribeFieldResult>> dfrBySObjType;
	static {
		dfrBySObjType = new Map<SObjectType, Map<String, DescribeFieldResult>>();
	}

	static Map<Boolean, Map<SObjectType, Map<String, RecordType>>> rtypesCache;
	static {
		rtypesCache = new Map<Boolean, Map<SObjectType, Map<String, RecordType>>>();
		rtypesCache.put(true, new Map<SObjectType, Map<String, RecordType>>());
		rtypesCache.put(false, new Map<SObjectType, Map<String, RecordType>>());
	}

	static Map<SObjectType, Map<String, ChildRelationship>> relCache;
	static {
		relCache = new Map<SObjectType, Map<String, ChildRelationship>>();
	}

	static Map<String, Map<Integer, String>> repeatCache;
	static {
		repeatCache = new Map<String, Map<Integer, String>>();
	}

	static Map<SObjectType, Map<Id, SObject>> findCache;
	static {
		findCache = new Map<SObjectType, Map<Id, SObject>>();
	}

	global static Boolean isStringType(DisplayType dt) {
		return STRING_TYPES.contains(dt);
	}

	global static Boolean isIntegerType(DisplayType dt) {
		return INTEGER_TYPES.contains(dt);
	}

	global static Boolean isIdType(DisplayType dt) {
		return ID_TYPES.contains(dt);
	}

	global static Boolean isDoubleType(DisplayType dt) {
		return DOUBLE_TYPES.contains(dt);
	}

	global static Boolean isDatetimeType(DisplayType dt) {
		return DATETIME_TYPES.contains(dt);
	}

	global static Boolean isDateType(DisplayType dt) {
		return DATE_TYPES.contains(dt);
	}

	global static Boolean isBooleanType(DisplayType dt) {
		return BOOLEAN_TYPES.contains(dt);
	}

	/* String utilities
	 */


	/**
	 * Format a string with a list of parameters. If obj is not a list and is convertable
	 * into a String, we use the delim to split into a list. But if delim is null and obj
	 * can be a String, it will not be split.
	 */
	global static String format(String format, Object obj, String delim) {
		if (format == null) {
			format = '';
		}
		if (obj == null) {
			obj = '';
		}
		else if (obj instanceof List<String>) {
			obj = String.join((List<String>) obj, delim = DEFAULT_DELIM);
		}
		return String.format(format, split(String.valueOf(obj), delim));
	}

	global static String format(String format, Object obj) {
		return format(format, obj, DEFAULT_DELIM);
	}

	/**
	 * Null-safe string split.
	 */
	global static List<String> split(String str, String delim) {
		return str == null ? null : delim == null ? new List<String> {str} : str.split(delim);
	}

	global static List<String> explode(String str) {
		List<String> result;
		if (str != null) {
			result = str.split('');
			result.remove(0);
		}
		return result;
	}

	/**
	 * Finds n-th index of searchStr within str. Null-safe.
	 */
	global static Integer ordinalIndexOf(String str, String searchStr, Integer ordinal) {
		Integer index = -1;
		if (str != null && searchStr != null && ordinal > 0) {
			if (searchStr.length() == 0) {
				index = str.length();
			}
			else {
				Integer found = 0;
				while (found < ordinal) {
					index = str.indexOf(searchStr, index + 1);
					if (index < 0) {
						break;
					}
					found++;
				}
			}
		}
		return index;
	}

	/**
	 * Helper for adjusting to various substring error cases.
	 */
	global static String substring(String str, Integer startIndex, Integer endIndex) {
		String res;
		if (str != null) {
			if (startIndex == null || startIndex < 0) {
				startIndex = 0;
			}
			if (endIndex == null || endIndex > str.length()) {
				endIndex = str.length();
			}
			if (startIndex > endIndex) {
				startIndex = endIndex;
			}
			res = str.substring(startIndex, endIndex);
		}
		return res;
	}

	/**
	 * Helper for adjusting to various substring error cases.
	 */
	global static String substring(String str, Integer startIndex) {
		return substring(str, startIndex, null);
	}

	/**
	 * Null-safe String.normalizeSpace
	 */
	global static String normalizeSpace(String str) {
		return str == null ? null : str.normalizeSpace();
	}

	global static String convertLineEndings(String str) {
		return str.replace(CRLF, LF).replace(CR, LF);
	}

	/**
	 * Null-safe String.toLowerCase
	 */
	global static String lowerCase(String str) {
		return lowerCase(str, null);
	}

	/**
	 * Null-safe String.toLowerCase. Locale optional.
	 */
	global static String lowerCase(String str, String locale) {
		return str == null ? null : str.toLowerCase(locale == null ? 'en' : locale);
	}

	/**
	 * Null-safe String.toUpperCase
	 */
	global static String upperCase(String str) {
		return upperCase(str, null);
	}

	/**
	 * Null-safe String.toUpperCase. Locale optional.
	 */
	global static String upperCase(String str, String locale) {
		return str == null ? null : str.toUpperCase(locale == null ? '' : locale);
	}

	/**
	 * Repeats the given string n times.
	 */
	global static String repeat(String str, Integer n) {
		if (str == null) {
			str = '';
		}
		if (n == null) {
			n = 0;
		}
		Map<Integer, String> cached = repeatCache.get(str);
		if (cached == null) {
			repeatCache.put(str, cached = new Map<Integer, String>());
		}
		String res = cached.get(n);
		if (res == null) {
			String[] arr = new String[n];
			for (Integer i = 0; i < n; i++) {
				arr[i] = str;
			}
			cached.put(n, res = String.join(arr, ''));
		}
		return res;
	}

	global static String blankValue(String str, String value) {
		return String.isBlank(str) ? value : str;
	}


	/* Number utilities
	 */


	global static Boolean isNullOrZero(Object n) {
		return n == null || n == 0;
	}

	global static Integer nullValue(Integer n, Integer val) {
		return Integer.valueOf(nullValue((Decimal) n, (Decimal) val));
	}

	global static Decimal nullValue(Decimal n, Decimal val) {
		return n == null ? val : n;
	}

	/**
	 * Check if object is not a Decimal, Double, Integer, or Long.
	 */
	global static Boolean isNaN(Object o) {
		return o == null || !(o instanceof Decimal || o instanceof Double || o instanceof Integer || o instanceof Long);
	}

	/**
	 * Generate a random integer between zero and UP TO max.
	 */
	global static Integer randomInt(Integer max) {
		return (Math.random() * (max + 1)).intValue();
	}

	global static Integer compare(Object a, Object b, Integer defaultValue) {
		Integer result = defaultValue;
		if (!isNaN(a) && !isNaN(b)) {
			Double m = toDouble(a, null);
			Double n = toDouble(b, null);
			if (m != null && n != null) {
				result = m < n ? -1 : m > n ? 1 : 0;
			}
		}
		else if (isDate(a) && isDate(b)) {
			DateTime m = toDateTime(a);
			DateTime n = toDateTime(b);
			if (m != null && n != null) {
				result = m < n ? -1 : m > n ? 1 : 0;
			}
		}
		return result;
	}

	global static Integer compare(Object a, Object b) {
		return compare(a, b, -1);
	}

	global static Double toDouble(Object obj, Double defaultValue) {
		Double result = defaultValue;
		if (obj != null && obj instanceof Boolean) {
			obj = (Boolean) obj ? 1 : 0;
		}
		if (!isNaN(obj) || obj instanceof String) {
			try {
				Double d = Double.valueOf(obj);
				result = d;
			}
			catch (Exception e) {}
		}
		return result;
	}

	global static Double toDouble(Object obj) {
		return toDouble(obj, 0);
	}

	global static Decimal toDecimal(Object obj, Decimal defaultValue) {
		return toDouble(obj, Double.valueOf(defaultValue));
	}

	global static Decimal toDecimal(Object obj) {
		return toDouble(obj, 0);
	}

	global static Integer toInteger(Object obj, Integer defaultValue) {
		return Integer.valueOf(toDouble(obj, Double.valueOf(defaultValue)));
	}

	global static Integer toInteger(Object obj) {
		return Integer.valueOf(toDouble(obj, 0));
	}

	global static Long toLong(Object obj, Long defaultValue) {
		return (Long) toDouble(obj, Double.valueOf(defaultValue));
	}

	global static Long toLong(Object obj) {
		return (Long) toDouble(obj, 0);
	}

	global static Boolean inIntRange(Long l) {
		return l >= MIN_INTEGER && l <= MAX_INTEGER;
	}

	/* Date/DateTime utilities
	 */

	global static Boolean isDate(Object o) {
		return o != null && (o instanceof Date || o instanceof DateTime);
	}

	global static Date toDate(Object obj) {
		Date result;
		if (obj != null) {
			if (obj instanceof Date) {
				result = (Date) obj;
			}
			else if (obj instanceof String && isValidDate(obj)) {
				try {
					result = Date.parse((String) obj);
				}
				catch (Exception e) {
					try {
						result = (Date) JSON.deserialize((String) obj, Date.class);
					}
					catch (Exception e2) {
						result = null;
					}
				}
			}
			else {
				DateTime dt = toDateTime(obj);
				if (dt != null) {
					result = dt.date();
				}
			}
		}
		return result;
	}

	global static DateTime toDateTime(Object obj) {
		DateTime result;
		if (obj != null) {
			if (obj instanceof Date) {
				Date d = (Date) obj;
				result = DateTime.newInstance(d.year(), d.month(), d.day());
			}
			else if (obj instanceof DateTime) {
				result = (DateTime) obj;
			}
			else if (!isNaN(obj)) {
				result = DateTime.valueOf(obj);
			}
			else if (obj instanceof String && isValidDateTime(obj)) {
				try {
					result = DateTime.parse((String) obj);
				}
				catch (Exception e) {
					try {
						result = (DateTime) JSON.deserialize((String) obj, DateTime.class);
					}
					catch (Exception e2) {
						result = null;
					}
				}
			}
		}
		return result;
	}

	global static Boolean isValidDate(Object obj) {
		Boolean result;
		if (obj == null || !isNaN(obj)) {
			result = false;
		}
		else if (isDate(obj)) {
			result = true;
		}
		else {
			try {
				result = obj instanceof String && Date.parse((String) obj) != null;
			}
			catch (Exception e) {
				try {
					result = JSON.deserialize((String) obj, Date.class) != null;
				}
				catch (Exception e2) {
					result = false;
				}
			}
		}
		return result;
	}

	global static Boolean isValidDateTime(Object obj) {
		Boolean result;
		if (obj == null) {
			result = false;
		}
		else if (isDate(obj)) {
			result = true;
		}
		else {
			try {
				DateTime dt;
				if (!isNaN(obj)) {
					dt = DateTime.valueOf(obj);
				}
				else if (obj instanceof String) {
					try {
						dt = DateTime.valueOf(String.valueOf(obj));
					}
					catch (Exception e) {
						try {
							dt = (DateTime) JSON.deserialize((String) obj, DateTime.class);
						}
						catch (Exception e2) {
							dt = null;
						}
					}
				}
				result = dt != null;
			}
			catch (Exception e) {
				result = false;
			}
		}
		return result;
	}


	/* Boolean utilities
	 */


	global static Boolean toBoolean(Object o) {
		return toBoolean(o, null);
	}

	global static Boolean toBoolean(Object o, Boolean defaultValue) {
		try {
			return Boolean.valueOf(o);
		}
		catch (Exception e) {
			return defaultValue;
		}
	}


	/* Array utilities
	 */


	/**
	 * Returns the first object in a list, otherwise null.
	 */
	global static Object first(List<Object> records) {
		return isEmpty(records) ? null : records.get(0);
	}

	global static Boolean isEmpty(List<Object> records) {
		return records == null || records.isEmpty();
	}

	global static Boolean isEmpty(List<SObject> records) {
		return records == null || records.isEmpty();
	}

	global static Boolean isNotEmpty(List<Object> records) {
		return !isEmpty(records);
	}

	global static Boolean isNotEmpty(List<SObject> records) {
		return !isEmpty(records);
	}

	global static List<Object> pluck(List<SObject> records, String field) {
		List<Object> plucked;
		if (isNotEmpty(records) && String.isNotBlank(field)) {
			plucked = new Object[records.size()];
			for (Integer i = 0; i < records.size(); i++) {
				plucked.set(i, records.get(i).get(field));
			}
		}
		else {
			plucked = new List<Object>();
		}
		return plucked;
	}

	global static List<Object> pluck(List<SObject> records, SObjectField sfield) {
		return pluck(records, '' + sfield);
	}

	global static List<String> toLowerCase(List<String> strings) {
		List<String> results;
		if (strings != null) {
			results = new List<String>();
			for (String str : strings) {
				if (str != null) {
					results.add(str.toLowerCase());
				}
			}
		}
		return results;
	}

	/**
	 * Flatten a multi-dimensional List.
	 */
	global static List<Object> flatten(List<Object> objs) {
		List<Object> flattened;
		if (objs != null) {
			flattened = new List<Object>();
			for (Object obj : objs) {
				List<Object> sub;
				if (obj != null && obj instanceof List<Object>) {
					sub = flatten((List<Object>) obj);
				}
				else {
					sub = new List<Object> {obj};
				}
				flattened.addAll(sub);
			}
		}
		return flattened;
	}

	/**
	 * Finds the index from an array given an object to find. Assumes array is
	 * not sorted. If the array is known to be sorted, use binary search.
	 */
	global static Integer indexOf(List<Object> objs, Object value, Integer fromIndex) {
		Integer index = -1;
		if (fromIndex == null || fromIndex < 0) {
			fromIndex = 0;
		}
		if (objs != null) {
			for (Integer i = fromIndex; i < objs.size(); i++) {
				if (objs.get(i) == value) {
					index = i;
					break;
				}
			}
		}
		return index;
	}

	global static Integer indexOf(List<Object> objs, Object value) {
		return indexOf(objs, value, null);
	}

	/**
	 * Performs a binary search of a sorted array using direct comparison operations.
	 */
	global static Integer binarySearch(List<String> sortedList, String value) {
		Integer lo = 0;
		Integer hi = sortedList.size() - 1;
		while (lo <= hi) {
			Integer mid = lo + (hi - lo) / 2;
			String item = sortedList.get(mid);
			if (value < item) {
				hi = mid - 1;
			}
			else if (value > item) {
				lo = mid + 1;
			}
			else {
				return mid;
			}
		}
		return -1;
	}

	/**
	 * Convert objects to strings using String.valueOf on each element.
	 */
	global static List<String> asStrings(List<Object> objs) {
		List<String> result;
		if (objs != null) {
			result = new List<String>();
			for (Object o : objs) {
				result.add(String.valueOf(o));
			}
		}
		return result;
	}

	/* Set utilities
	 */

	global static Set<Id> intersectIds(Set<Id> a, Set<Id> b) {
		Set<Id> res;
		if (a != null && b != null) {
			res = a.clone();
			res.retainAll(b);
		}
		return res == null ? new Set<Id>() : res;
	}

	global static String sampleStrings(Set<String> strings) {
		String res;
		if (strings != null) {
			for (String str : strings) {
				res = str;
				break;
			}
		}
		return res;
	}

	global static Id sampleIds(Set<Id> ids) {
		Id res;
		if (ids != null) {
			for (Id id : ids) {
				res = id;
				break;
			}
		}
		return res;
	}

	global static String join(Set<String> strings, String del) {
		if (del == null) {
			del = '';
		}
		return String.join(new List<String>(strings), del);
	}

	global static String join(Set<Id> ids, String del) {
		if (del == null) {
			del = '';
		}
		return String.join(new List<Id>(ids), del);
	}

	global static Set<String> toLowerCase(Set<String> strings) {
		Set<String> results;
		if (strings != null) {
			results = new Set<String>();
			for (String str : strings) {
				if (str != null) {
					results.add(str.toLowerCase());
				}
			}
		}
		return results;
	}

	global static Boolean containsIgnoreCase(Set<String> stringSet, String str) {
		for (String item : stringSet) {
			if (str == item) {
				return true;
			}
		}
		return false;
	}

	global static Set<Object> toSet(List<Object> objs) {
		return new Set<Object>(objs);
	}

	global static Set<Id> toIdSet(List<Object> objs) {
		Set<Id> res = new Set<Id>();
		for (Object obj : objs) {
			res.add((Id) obj);
		}
		return res;
	}

	global static Set<Object> pluckToSet(List<SObject> records, String field) {
		return toSet(pluck(records, field));
	}

	global static Set<Object> pluckToSet(List<SObject> records, SObjectField sfield) {
		return pluckToSet(records, '' + sfield);
	}

	global static Set<Id> pluckToIdSet(List<SObject> records, String field) {
		return toIdSet(pluck(records, field));
	}

	global static Set<Id> pluckToIdSet(List<SObject> records, SObjectField sfield) {
		return pluckToIdSet(records, '' + sfield);
	}

	/**
	 * Creates a duplicate-free version of a list using equality comparisons,
	 * in which only the first occurrence of each element is kept. Retains list order.
	 */
	global static List<Object> uniq(List<Object> objs) {
		return uniq(objs, false);
	}

	global static List<Object> uniq(List<Object> objs, Boolean inPlace) {
		return uniq(objs, false, inPlace);
	}

	/**
	 * An implementation of .uniq optimized for sorted lists.
	 */
	global static List<Object> uniq(List<Object> objs, Boolean sorted, Boolean inPlace) {
		List<Object> res = new List<Object>();
		if (!sorted) {
			objs.sort();
		}
		Object seen;
		Integer len = objs.size();
		for (Integer i = 0; i < len; i++) {
			Object value = objs.get(i);
			if (i == 0 || seen != value) {
				seen = value;
				res.add(value);
			}
		}
		if (inPlace) {
			objs.clear();
			objs.addAll(res);
			res = objs;
		}
		return res;
	}

	global static List<SObject> uniqRecords(List<SObject> records) {
		if (records != null) {
			Map<Id, SObject> res = new Map<Id, SObject>();
			for (SObject record : records) {
				res.put(record.Id, record);
			}
			return res.values();
		}
		return null;
	}

	/* Map utilities
	 */

	/**
	 * Groups a list of records by the value of a given "String" field (Id or text)
	 * @param records List of records
	 * @param sfield "String" field to group records by
	 * @return Mapping of value to list of records; both must be cast to intended type
	 */
	global static Map<String, List<SObject>> groupByStringField(List<SObject> records, SObjectField sfield) {
		Map<String, List<SObject>> mappings = new Map<String, List<SObject>>();
		for (SObject record : records) {
			String value = String.valueOf(record.get(sfield));
			List<SObject> byValue;
			if ((byValue = mappings.get(value)) == null) {
				mappings.put(value, byValue = new List<SObject>());
			}
			byValue.add(record);
		}
		return mappings;
	}

	/* SOQL utilities
	 */


	/** Takes all field names on an SObject and generates a comma-separated String.
	 */
	global static String getCommaSeparatedFields(SObjectType stype) {
		return getCommaSeparatedFields(stype, null);
	}

	/**
	 * Takes all field names on an SObject and generates a comma-separated String.
	 */
	global static String getCommaSeparatedFields(SObjectType stype, String prepend) {
		String fields;
		if (stype != null) {
			fields = join(sObjectFieldNames(stype, prepend), ',');
		}
		return fields;
	}

	/**
	 * Generate a base query for an SObject with all fields referenced.
	 */
	global static String getBaseQuery(SObjectType stype) {
		return getBaseQuery(stype, null);
	}

	/**
	 * Generate a base query for an SObject with all fields referenced.
	 * @param whereClause  String to be appended after the WHERE keyword.
	 */
	global static String getBaseQuery(SObjectType stype, String whereClause) {
		return getBaseQuery(stype, new Set<String>(), whereClause);
	}

	/**
	 * Generate a base query for an SObject with all fields referenced.
	 * @param relationshipNames  Master-detail relationship names on the given SObject, of which
	 *                           all fields on the child SObjects will be referenced.
	 * @param whereClause        String to be appended after the WHERE keyword.
	 */
	global static String getBaseQuery(SObjectType stype, Set<String> relationshipNames, String whereClause) {
		return getBaseQuery(stype, relationshipNames, new Set<SObjectField>(), whereClause);
	}

	/**
	 * Generate a base query for an SObject with all fields referenced.
	 * @param relationshipNames  Master-detail relationship names on the given SObject, of which
	 *                           all fields on the child SObjects will be referenced.
	 * @param lookupSFields      SObject lookups of which will have their own fields included.
	 *                           Supports only single-depth.
	 * @param whereClause        String to be appended after the WHERE keyword.
	 */
	global static String getBaseQuery(SObjectType stype, Set<String> relationshipNames, Set<SObjectField> lookupSFields, String whereClause) {
		String q;
		if (stype != null) {
			// pick up requested relationships, silently ignoring invalid relationships
			List<ChildRelationship> relationships = new List<ChildRelationship>();
			if (relationshipNames != null && !relationshipNames.isEmpty()) {
				relationshipNames = toLowerCase(relationshipNames);
				Map<String, ChildRelationship> rels = getChildRelationships(stype);
				for (String relName : rels.keySet()) {
					if (relName != null && relationshipNames.contains(relName.toLowerCase())) {
						relationships.add(rels.get(relName));
					}
				}
			}
			// pick up requested lookups and map their fields.
			Set<String> lookups = new Set<String>();

			Set<SObjectField> sobjLookups = new Set<SObjectField>(sObjectFields(stype));
			sobjLookups.retainAll(lookupSFields);

			// build query
			q = 'SELECT ' + getCommaSeparatedFields(stype);
			for (SObjectField field : sobjLookups) {
				DescribeFieldResult dfr = field.getDescribe();
				if (!dfr.isNamePointing()) {
					SObjectType fieldSType = dfr.getReferenceTo().get(0);
					q += ',' + getCommaSeparatedFields(fieldSType, dfr.getRelationshipName() + '.');
				}
			}
			for (ChildRelationship relationship : relationships) {
				q += ',(' + getRelationshipSubQuery(relationship) + ')';
			}
			q += ' FROM ' + stype;
			if (whereClause != null) {
				q += ' WHERE ' + whereClause;
			}
		}
		return q;
	}

	/**
	 * Generate the subquery of a given ChildRelationship.
	 */
	global static String getRelationshipSubQuery(ChildRelationship relationship) {
		return getRelationshipSubQuery(relationship, null);
	}

	global static String getRelationshipSubQuery(ChildRelationship relationship, String whereClause) {
		String res;
		if (relationship != null) {
			SObjectType stype = relationship.getChildSObject();
			DescribeSObjectResult dsr = stype.getDescribe();
			res = 'SELECT ' + getCommaSeparatedFields(stype) + ' FROM ' + relationship.getRelationshipName();
			if (whereClause != null) {
				res += ' WHERE ' + whereClause;
			}
		}
		return res;
	}

	/**
	 * Generate a base query appended by an Id condition bound to a String/Id parameter 'id'.
	 */
	global static String getByIdQuery(SObjectType stype) {
		return getByIdQuery(stype, null);
	}

	global static String getByIdQuery(SObjectType stype, String whereClause) {
		String res;
		if (stype != null) {
			res = getBaseQuery(stype, 'Id=:id');
			if (String.isNotBlank(whereClause)) {
				res += ' AND (' + whereClause + ')';
			}
		}
		return res;
	}

	/**
	 * Generate a base query appended by an Id condition bound to a List/Set parameter 'ids'.
	 */
	global static String getByIdsQuery(SObjectType stype) {
		return getByIdsQuery(stype, null);
	}

	global static String getByIdsQuery(SObjectType stype, String whereClause) {
		String res;
		if (stype != null) {
			res = getBaseQuery(stype, 'Id IN:ids');
			if (String.isNotBlank(whereClause)) {
				res += ' AND (' + whereClause + ')';
			}
		}
		return res;
	}

	global static void addRecordsToCache(List<SObject> records) {
		if (records != null && !records.isEmpty()) {
			for (SObject record : records) {
				addRecordToCache(record);
			}
		}
	}

	global static void addRecordToCache(SObject record) {
		if (record != null && record.Id != null) {
			SObjectType stype = record.getSObjectType();
			Map<Id, SObject> recordCache;
			if ((recordCache = findCache.get(stype)) == null) {
				findCache.put(stype, recordCache = new Map<Id, SObject>());
			}
			recordCache.put(record.Id, record);
		}
	}

	global static SObject getRecordFromCache(Id id) {
		SObject res;
		if (id != null) {
			SObjectType stype = id.getSobjectType();
			Map<Id, SObject> recordCache = findCache.get(stype);
			if (recordCache != null) {
				res = recordCache.get(id);
			}
		}
		return res;
	}

	global static List<SObject> getRecordsFromCache(Set<Id> ids) {
		List<SObject> res = new List<SObject>();
		if (ids != null && !ids.isEmpty()) {
			for (Id id : ids) {
				if (id != null) {
					res.add(getRecordFromCache(id));
				}
			}
		}
		return res;
	}

	/**
	 * Find an SObject by Id
	 */
	global static SObject findSObject(SObjectType stype, Id id) {
		return findSObject(stype, id, false);
	}

	global static SObject findSObject(SObjectType stype, Id id, Boolean useCache) {
		SObject res;
		if (stype != null && id != null) {
			if (useCache) {
				res = getRecordFromCache(id);
			}
			if (res == null) {
				res = (SObject) first(Database.query(getByIdQuery(stype)));
				addRecordToCache(res);
			}
		}
		return res;
	}

	global static SObject findSObject(Id id) {
		return findSObject(id, false);
	}

	global static SObject findSObject(Id id, Boolean useCache) {
		if (id == null) {
			return null;
		}
		return findSObject(id.getSobjectType(), id, useCache);
	}

	global static List<SObject> findSObjects(SObjectType stype, Set<Id> ids) {
		List<SObject> res;
		if (stype != null) {
			if (ids == null || ids.isEmpty()) {
				res = new List<SObject>();
			}
			else {
				res = Database.query(getByIdsQuery(stype));

			}
		}
		return res;
	}

	global static List<SObject> findAll(SObjectType stype) {
		List<SObject> records;
		if (stype != null) {
			records = Database.query(getBaseQuery(stype));
		}
		return records == null ? new List<SObject>() : records;
	}

	global static SObject findOne(SObjectType stype) {
		List<SObject> records;
		if (stype != null) {
			records = Database.query(getBaseQuery(stype) + ' LIMIT 1');
		}
		return (SObject) first(records);
	}

	global static SObject findOne(SObjectType stype, String whereClause) {
		List<SObject> records;
		if (stype != null) {
			String q = getBaseQuery(stype);
			if (String.isNotBlank(whereClause)) {
				q += ' WHERE ' + whereClause;
			}
			records = Database.query(q + ' LIMIT 1');
			addRecordsToCache(records);
		}
		return (SObject) first(records);
	}

	global static Map<String, DescribeFieldResult> getDescribeFieldResultsByRel(SObjectType stype) {
		Map<String, DescribeFieldResult> describes = getDescribeFieldResults(stype);
		Map<String, DescribeFieldResult> res = new Map<String, DescribeFieldResult>();
		for (DescribeFieldResult dfr : describes.values()) {
			String relName = dfr.getRelationshipName();
			if (String.isNotBlank(relName)) {
				res.put(relName.toLowerCase(), dfr);
			}
		}
		return res;
	}

	global static Boolean isValidFieldReference(SObjectType stype, String field) {
		if (stype != null && field != null) {
			field = field.toLowerCase();
			Map<String, DescribeFieldResult> describesByRel = getDescribeFieldResultsByRel(stype);

			if (field.contains('.')) {
				String nextField = field.substringAfter('.');
				String relation = field.substringBefore('.');
				DescribeFieldResult fieldDescribe = describesByRel.get(relation);
				if (fieldDescribe != null) {
					for (SObjectType relSType : fieldDescribe.getReferenceTo()) {
						if (isValidFieldReference(relSType, nextField)) {
							return true;
						}
					}
				}
			}
			else {
				Set<String> fields = sObjectFieldNames(stype);
				return fields.contains(field);
			}
		}
		return false;
	}

	/**
	 * Get reference value of an SObject given a field path string.
	 * @param quoted If true, quotes are added for types where SOQL requires them.
	 */
	global static String getReferenceValue(String field, SObject sObj, Boolean quoted) {
		String res;
		if (sObj != null && field != null) {
			if (field.contains('.')) {
				String nextField = field.substringAfter('.');
				String relation = field.substringBefore('.');
				res = getReferenceValue(nextField, sObj.getSObject(relation), quoted);
			}
			else if (sObj.get(field) != null) {
				res = String.valueOf(sObj.get(field));
				if (quoted == null) {
					quoted = false;
				}
				if (quoted) {
					DisplayType dt = getDisplayType(sObj.getSObjectType(), field);
					res = dt == null ? null : getSoqlQuotedValue(dt, res);
				}
			}
		}
		return res;
	}

	global static String getReferenceValue(String field, SObject sObj) {
		String res;
		if (sObj != null && String.isNotBlank(field)) {
			res = getReferenceValue(field, sObj, false);
		}
		return res;
	}

	global static Map<String, String> getReferenceValues(Set<String> fields, SObject sObj, Boolean quoted) {
		Map<String, String> valueMap;
		if (fields != null && sObj != null) {
			valueMap = new Map<String, String>();
			for (String field : fields) {
				valueMap.put(field, getReferenceValue(field, sObj, quoted));
			}
		}
		return valueMap;
	}

	global static Map<String, String> getReferenceValues(Set<String> fields, SObject sObj) {
		Map<String, String> refValues;
		if (fields != null && sObj != null) {
			refValues = getReferenceValues(fields, sObj, false);
		}
		return refValues;
	}

	global static String getSoqlQuotedValue(DisplayType dt, String value) {
		return (isStringType(dt) || isIdType(dt)) ? '\'' + value + '\'' : value;
	}


	/* Schema describe utilities
	 */

	global static SObjectType getSObjectType(String name) {
		return GD.get(name);
	}

	global static String sObjectTypeName(SObject sObj) {
		String name;
		if (sObj != null) {
			name = String.valueOf(sObj.getSObjectType());
		}
		return name;
	}

	global static String sObjectTypeName(Id id) {
		String name;
		if (id != null) {
			name = String.valueOf(id.getSObjectType());
		}
		return name;
	}

	global static String sObjectTypeName(SObjectType stype) {
		String name;
		if (stype != null) {
			name = String.valueOf(stype);
		}
		return name;
	}

	global static Set<SObjectType> sObjectTypes(List<SObject> sobjs) {
		Set<SObjectType> stypes;
		if (sobjs != null) {
			stypes = new Set<SObjectType>();
			for (SObject sobj : sobjs) {
				if (sobj != null) {
					stypes.add(sobj.getSObjectType());
				}
			}
		}
		return stypes;
	}

	global static Set<String> sObjectTypeNames(List<SObject> sobjs) {
		Set<String> names;
		if (sobjs != null) {
			names = new Set<String>();
			for (SObjectType stype : sObjectTypes(sobjs)) {
				names.add('' + stype);
			}
		}
		return names;
	}

	global static Set<String> sObjectTypeNames(Set<Id> ids) {
		Set<String> names;
		if (ids != null) {
			names = new Set<String>();
			ids.remove(null);
			for (Id id : ids) {
				names.add(sObjectTypeName(id));
			}
		}
		return names;
	}

	global static Set<String> sObjectTypeNames(List<Id> ids) {
		Set<String> names;
		if (ids != null) {
			names = sObjectTypeNames(new Set<Id>(ids));
		}
		return names;
	}

	global static Map<String, DescribeFieldResult> getDescribeFieldResults(SObjectType stype) {
		Map<String, DescribeFieldResult> dfrMap;
		if (stype != null) {
			dfrMap = dfrBySObjType.get(stype);
			if (!dfrBySObjType.containsKey(stype)) {
				dfrBySObjType.put(stype, dfrMap = new Map<String, DescribeFieldResult>());
			}
			if (dfrMap.isEmpty()) {
				Map<String, SObjectField> fieldMap = sObjectFieldMap(stype);
				for (String fieldName : fieldMap.keySet()) {
					DescribeFieldResult dfr = fieldMap.get(fieldName).getDescribe();
					dfrMap.put(fieldName.toLowerCase(), dfr);
				}
			}
		}
		return dfrMap;
	}

	global static DescribeSObjectResult getDescribe(String type) {
		DescribeSObjectResult dsr;
		SObjectType stype = GD.get(type);
		if (stype != null) {
			dsr = stype.getDescribe();
		}
		return dsr;
	}

	global static DescribeFieldResult getDescribe(String type, String field) {
		DescribeFieldResult dfr;
		SObjectType stype = GD.get(type);
		Map<String, DescribeFieldResult> dfrs = getDescribeFieldResults(stype);
		if (dfrs != null) {
			dfr = dfrs.get(field.toLowerCase());
		}
		return dfr;
	}

	global static DisplayType getDisplayType(SObjectType stype, String field) {
		DisplayType dt;
		Map<String, DescribeFieldResult> dfrs = getDescribeFieldResults(stype);
		if (dfrs != null && field != null) {
			DescribeFieldResult dfr = dfrs.get(field.toLowerCase());
			if (dfr != null) {
				dt = dfr.getType();
			}
		}
		return dt;
	}

	global static DisplayType getDisplayType(SObjectField field) {
		DisplayType dt;
		if (field != null) {
			dt = field.getDescribe().getType();
		}
		return dt;
	}

	global static DisplayType getDisplayType(String type, String field) {
		return getDisplayType(GD.get(type), field);
	}

	/**
	 * Returns a map of active (user-available if applicable) RecordType IDs for a
	 * given SObjectType, keyed by DeveloperName.
	 */
	global static Map<String, Id> getRecordTypeIds(SObjectType stype, Boolean availableOnly) {
		Map<String, RecordType> mapRecordTypes = getRecordTypes(stype, availableOnly);
		Map<String, Id> mapRecordTypeIds = new Map<String, Id>();
		for (String devName : mapRecordTypes.keySet()) {
			mapRecordTypeIds.put(devName, mapRecordTypes.get(devName).Id);
		}
		return mapRecordTypeIds;
	}

	global static Map<String, Id> getRecordTypeIds(SObjectType stype) {
		return getRecordTypeIds(stype, false);
	}

	/**
	 * Returns a map of active (user-available if applicable) RecordTypes for a
	 * given SObjectType, keyed by DeveloperName.
	 */
	global static Map<String, RecordType> getRecordTypes(SObjectType stype, Boolean availableOnly) {
		Map<String, RecordType> mapRecordTypes;
		if (availableOnly == null) {
			availableOnly = false;
		}
		if (stype != null) {
			Map<SObjectType, Map<String, RecordType>> rtypeMap = rtypesCache.get(availableOnly);
			mapRecordTypes = rtypeMap.get(stype);
			if (mapRecordTypes == null) {
				rtypeMap.put(stype, mapRecordTypes = new Map<String, RecordType>());

				/* Obtain all active record types for the given SObjectType token. We will filter out the record
				 * types that are unavailable to the current user using Schema info (if availableOnly is true).
				 */
				List<RecordType> results = [ SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = :('' + stype) AND IsActive = true ];

				Map<Id, RecordTypeInfo> rtypeInfos;
				if (availableOnly) {
					rtypeInfos = stype.getDescribe().getRecordTypeInfosByID();
				}
				for (RecordType rt : results) {
					if (!availableOnly || rtypeInfos.get(rt.Id).isAvailable()) {
						mapRecordTypes.put(rt.DeveloperName, rt);
					}
				}
			}
		}
		return mapRecordTypes;
	}

	global static Map<String, RecordType> getRecordTypes(SObjectType stype) {
		return getRecordTypes(stype, null);
	}

	global static Map<Id, RecordType> getRecordTypesById(SObjectType stype, Boolean availableOnly) {
		Map<Id, RecordType> recordTypes = new Map<Id, RecordType>();
		for (RecordType rt : getRecordTypes(stype, availableOnly).values()) {
			recordTypes.put(rt.Id, rt);
		}
		return recordTypes;
	}

	global static Map<Id, RecordType> getRecordTypesById(SObjectType stype) {
		return getRecordTypesById(stype, null);
	}

	/**
	 * Returns a RecordType Id on a SObjectType by the given DeveloperName.
	 */
	global static Id getRecordTypeId(SObjectType stype, String developerName) {
		Id id;
		if (stype != null && String.isNotBlank(developerName)) {
			Map<String, Id> recordTypeIds = getRecordTypeIds(stype);
			// case-insensitive search
			for (String rtName : recordTypeIds.keySet()) {
				if (rtName == developerName) {
					id = recordTypeIds.get(rtName);
					break;
				}
			}
		}
		return id;
	}

	global static Boolean doesRecordTypeExist(SObjectType stype, String developerName) {
		return getRecordTypeId(stype, developerName) != null;
	}

	global static String getRecordTypeNameById(SObjectType stype, Id id) {
		String res;
		if (stype != null && id != null) {
			Map<String, Id> mapping = getRecordTypeIds(stype);
			for (String name : mapping.keySet()) {
				if (mapping.get(name) == id) {
					res = name;
					break;
				}
			}
		}
		return res;
	}

	global static Id getRecordTypeId(String type, String developerName) {
		return getRecordTypeId(GD.get(type), developerName);
	}

	global static Id getRecordTypeIdByName(SObjectType stype, String name) {
		Id id;
		if (stype != null && String.isNotBlank(name)) {
			DescribeSObjectResult dsr = stype.getDescribe();
			Map<String, RecordTypeInfo> rtInfos = dsr.getRecordTypeInfosByName();
			RecordTypeInfo rtInfo;
			for (String n : rtInfos.keySet()) {
				if (n == name) {
					rtInfo = rtInfos.get(n);
					break;
				}
			}
			if (rtInfo != null) {
				id = rtInfo.getRecordTypeId();
			}
		}
		return id;
	}

	global static Id getRecordTypeIdByName(String type, String name) {
		return getRecordTypeIdByName(GD.get(type), name);
	}

	/**
	 * Checks the schema global describe for existence
	 * of the given type (case-insensitive).
	 */
	global static Boolean sObjectTypeExists(String type) {
		return GD.containsKey(type);
	}

	/**
	 * Provides a mapping of SObjectFields, keyed by their lowercased names, that
	 * exist on the given SObjectType.
	 */
	global static Map<String, SObjectField> sObjectFieldMap(SObjectType stype) {
		if (stype != null) {
			return stype.getDescribe().fields.getMap();
		}
		return new Map<String, SObjectField>();
	}

	/**
	 * Provides a mapping of SObjectFields, keyed by their lowercased names, that
	 * exist on the given SObjectType (name is case-insensitive).
	 */
	global static Map<String, SObjectField> sObjectFieldMap(String type) {
		return sObjectFieldMap(GD.get(type));
	}

	global static Set<String> sObjectFieldNames(SObjectType stype) {
		return sObjectFieldNames(stype, null);
	}

	global static Set<String> sObjectFieldNames(SObjectType stype, String prepend) {
		return sObjectFieldNames('' + stype, prepend);
	}

	global static Set<String> sObjectFieldNames(String type) {
		return sObjectFieldNames(type, null);
	}

	global static Set<String> sObjectFieldNames(String type, String prepend) {
		Set<String> names;
		Map<String, SObjectField> fieldMap = sObjectFieldMap(type);
		if (fieldMap != null) {
			if (String.isNotBlank(prepend)) {
				names = new Set<String>();
				for (String name : fieldMap.keySet()) {
					names.add(prepend + name);
				}
			}
			else {
				names = fieldMap.keySet().clone();
			}
		}
		return names;
	}

	global static List<String> sObjectFieldNamesList(SObjectType stype) {
		return new List<String>(sObjectFieldNames(stype));
	}

	global static List<SObjectField> sObjectFields(SObjectType stype) {
		List<SObjectField> fields;
		Map<String, SObjectField> fieldMap = sObjectFieldMap(stype);
		if (fieldMap != null) {
			fields = fieldMap.values();
		}
		return fields;
	}

	global static List<SObjectField> sObjectFields(String type) {
		return sObjectFields(GD.get(type));
	}

	global static SObjectField sObjectField(SObjectType stype, String fieldName) {
		if (stype == null || String.isBlank(fieldName)) {
			return null;
		}
		return sObjectFieldMap(stype).get(fieldName.toLowerCase());
	}

	global static SObjectField sObjectField(String stypeName, String fieldName) {
		if (String.isBlank(stypeName) || String.isBlank(fieldName)) {
			return null;
		}
		SObjectType stype = getSObjectType(stypeName);
		return stype == null ? null : sObjectFieldMap(stype).get(fieldName.toLowerCase());
	}

	global static Map<String, ChildRelationship> getChildRelationships(SObjectType type) {
		Map<String, ChildRelationship> rels;
		if (type != null && (rels = relCache.get(type)) == null) {
			relCache.put(type, rels = new Map<String, ChildRelationship>());
			for (ChildRelationship rel : type.getDescribe().getChildRelationships()) {
				String relName = rel.getRelationshipName();
				if (relName != null) {
					rels.put(relName.toLowerCase(), rel);
				}
			}
		}
		return rels == null ? new Map<String, ChildRelationship>() : rels;
	}

	global static Set<String> getChildRelationshipNames(SObjectType stype) {
		return getChildRelationships(stype).keySet();
	}

	global static Set<String> diffSObjects(SObject o1, SObject o2) {
		Set<String> fieldDiff = new Set<String>();

		Map<String, Object> m1 = objectToMap(o1);
		Map<String, Object> m2 = objectToMap(o2);
		m1.remove('attributes');
		m2.remove('attributes');

		for (String k : m1.keyset()) {
			if (m1.get(k) != m2.get(k)) {
				fieldDiff.add(k);
			}
		}
		return fieldDiff;
	}

	global static Boolean isMixedSTypes(List<SObject> records) {
		if (records != null) {
			SObjectType prev;
			for (SObject record : records) {
				if (prev != null && prev != record.getSObjectType()) {
					return true;
				}
				prev = record.getSObjectType();
			}
		}
		return false;
	}

	global static SObject unsetFields(SObject record, Set<SObjectField> fieldsToUnset) {
		SObjectType stype = record.getSObjectType();
		Set<String> recordFields = objectToMap(record).keySet();
		recordFields.remove('attributes');
		List<String> fieldNamesToUnset = asStrings(new List<SObjectField>(fieldsToUnset));
		for (SObjectField f : fieldsToUnset) {
			String relName = f.getDescribe().getRelationshipName();
			if (relName != null) {
				fieldNamesToUnset.add(relName);
			}
		}
		if (recordFields.removeAll(fieldNamesToUnset)) {
			SObject newRecord = stype.newSObject();
			for (String f : recordFields) {
				newRecord.put(f, record.get(f));
			}
			record = newRecord;
		}
		return record;
	}

	global static SObject truncateFields(SObject record) {
		Map<String, DescribeFieldResult> dfrs = getDescribeFieldResults(record.getSObjectType());
		for (String fieldName : dfrs.keySet()) {
			if (record.get(fieldName) != null) {
				DescribeFieldResult dfr = dfrs.get(fieldName);
				if (isStringType(dfr.getType())) {
					String val = String.valueOf(record.get(fieldName));
					if (val.length() > dfr.getLength()) {
						record.put(fieldName, val.substring(0, dfr.getLength()));
					}
				}
			}
		}
		return record;
	}

	global static void sortSObjectFields(List<SObjectField> fields) {
		List<SortableSObjectField> sortables = new List<SortableSObjectField>();
		for (SObjectField field : fields) {
			sortables.add(new SortableSObjectField(field));
		}
		sortables.sort();
		fields.clear();
		for (SortableSObjectField sortable : sortables) {
			fields.add(sortable.value);
		}
	}

	global class SortableSObjectField implements Comparable {

		global SObjectField value;

		global SortableSObjectField(SObjectField value) {
			this.value = value;
		}

		global Integer compareTo(Object o) {
			if (!(o instanceof SortableSObjectField) || o == null) { return -1; }
			SortableSObjectField v = (SortableSObjectField) o;
			return String.valueOf(value).compareTo(String.valueOf(v.value));
		}
	}

	/* DML utilities
	 */


	global static Boolean isFieldQueried(SObject record, String field) {
		return isFieldQueried(record, sObjectField(record.getSObjectType(), field));
	}

	global static Boolean isFieldQueried(SObject record, SObjectField sfield) {
		try {
			record.get(sfield);
			return true;
		}
		catch (Exception e) {
			return false;
		}
	}


	/**
	 * Adheres to the chunk limit by grouping the given records together by their SObjectType.
	 * @return List of SObject lists, each of which is a group of up to 10 chunks.
	 */
	global static List<List<SObject>> fixChunks(List<SObject> records) {
		final Integer CHUNK_LIMIT = 10;

		List<List<SObject>> results = new List<List<SObject>>();
		Map<SObjectType, List<SObject>> recordsByType = new Map<SObjectType, List<SObject>>();

		for (SObject record : records) {
			SObjectType type = record.getSObjectType();
			List<SObject> byType = recordsByType.get(type);
			if (byType == null) {
				recordsByType.put(type, byType = new List<SObject>());
			}
			byType.add(record);
		}
		while (!recordsByType.isEmpty()) {
			List<SObject> grouped = new List<SObject>();
			Integer n = 0;
			for (SObjectType type : recordsByType.keySet()) {
				if (n++ >= CHUNK_LIMIT) {
					break;
				}
				grouped.addAll(recordsByType.get(type));
				recordsByType.remove(type);
			}
			results.add(grouped);
		}
		return results;
	}

	/* URL utilities
	 */


	global static String buildUrl(String baseUrl, Map<String, String> params) {
		if (params == null || params.isEmpty()) {
			return baseUrl;
		}
		PageReference pageRef = new PageReference(baseUrl);
		pageRef.getParameters().putAll(params);
		return pageRef.getUrl();
	}


	/* ApexPages utilities
	 */


	global static ApexPages.StandardSetController toSetController(ApexPages.StandardController sc) {
		List<SObject> records = new SObject[1];
		records.add(sc.getRecord());
		return new ApexPages.StandardSetController(records);
	}

	global static String getParam(String key) {
		return ApexPages.currentPage().getParameters().get(key);
	}

	global static void setParam(String key, String value) {
		ApexPages.currentPage().getParameters().put(key, value);
	}

	global static PageReference pageRef(SObject sObj, String type, Boolean redirect) {
		if (sObj == null) {
			return null;
		}
		ApexPages.StandardController sc = new ApexPages.StandardController(sObj);
		PageReference pageRef;
		if (type == 'edit') {
			pageRef = sc.edit();
		}
		else if (type == 'cancel') {
			pageRef = sc.cancel();
		}
		else if (type == 'save') {
			pageRef = sc.save();
		}
		else if (type == 'delete') {
			pageRef = sc.delete();
		}
		else {
			pageRef = sc.view();
		}
		pageRef.setRedirect(redirect == null ? false : redirect);
		return pageRef;
	}

	global static PageReference pageRef(SObject sObj, String type) {
		return pageRef(sObj, type, true);
	}

	global static PageReference pageRef(SObject sObj) {
		return pageRef(sObj, 'view');
	}

	global static PageReference pageRef(Id id, String type, Boolean redirect) {
		return pageRef(id.getSobjectType().newSObject(id), type, redirect);
	}

	global static PageReference pageRef(Id id, String type) {
		return pageRef(id, type, true);
	}

	global static PageReference pageRef(Id id) {
		return pageRef(id, 'view');
	}

	global static PageReference pageRef(String str, Boolean redirect) {
		PageReference pageRef = new PageReference(str);
		pageRef.setRedirect(redirect);
		return pageRef;
	}

	global static PageReference pageRef(String str) {
		return pageRef(str, true);
	}

	global static void addConfirmMessage(String msg) {
		System.debug(LoggingLevel.DEBUG, msg);
		if (ApexPages.currentPage() != null) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, msg));
		}
	}

	global static void addErrorMessage(String msg) {
		System.debug(LoggingLevel.ERROR, msg);
		if (ApexPages.currentPage() != null) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));
		}
	}

	global static void addFatalMessage(String msg) {
		System.debug(LoggingLevel.ERROR, msg);
		if (ApexPages.currentPage() != null) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, msg));
		}
	}

	global static void addInfoMessage(String msg) {
		System.debug(LoggingLevel.DEBUG, msg);
		if (ApexPages.currentPage() != null) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, msg));
		}
	}

	global static void addWarningMessage(String msg) {
		System.debug(LoggingLevel.DEBUG, msg);
		if (ApexPages.currentPage() != null) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, msg));
		}
	}


	/* Limits utilities
	 */

	global static Integer getAvailableQueueableJobs() {
		return Limits.getLimitQueueableJobs() - Limits.getQueueableJobs();
	}

	global static Integer getAvailableFutureCalls() {
		if (System.isFuture() || System.isBatch() && !System.isQueueable()) {
			return 0;
		}
		return Limits.getLimitFutureCalls() - Limits.getFutureCalls();
	}

	global static Boolean isFutureCallAllowed() {
		return getAvailableFutureCalls() > 0;
	}

	global static Integer getAvailableQueries() {
		return Limits.getLimitQueries() - Limits.getQueries();
	}

	global static Integer getAvailableQueryRows() {
		return Limits.getLimitQueryRows() - Limits.getQueryRows();
	}

	global static Integer getAvailableDMLRows() {
		return Limits.getLimitDMLRows() - Limits.getDMLRows();
	}

	global static Integer getAvailableDMLStatements() {
		return Limits.getLimitDMLStatements() - Limits.getDMLStatements();
	}

	global static Boolean willHitQueryLimits(Integer nQueries, Integer nRows) {
		return getAvailableQueries() <= nQueries - 1 ||
		       getAvailableQueryRows() <= nRows - 1;
	}

	global static Boolean willHitDmlLimits(Integer nRows, Integer nStatements) {
		return getAvailableDMLRows() <= nRows - 1 ||
		       getAvailableDMLStatements() <= nStatements - 1;
	}


	/* Select list utilities
	 */


	global static List<SelectOption> createSelectList(List<SObject> sObjs, String valueField, String labelField, Boolean blankOpt) {
		List<SelectOption> opts;
		if (sObjs != null) {
			opts = new List<SelectOption>();
			if (blankOpt) {
				opts.add(new SelectOption('', STR_OPT_NONE));
			}
			// build list such that each option id is unique.
			List<String> orderedKeys = new List<String>();
			Map<String, String> selectMap = new Map<String, String>();
			for (SObject sObj : sObjs) {
				Object value = sObj.get(valueField);
				Object label = sObj.get(labelField);
				if (value != null && label != null && !selectMap.containsKey(String.valueOf(value))) {
					selectMap.put(String.valueOf(value), String.valueOf(label));
					orderedKeys.add(String.valueOf(value));
				}
			}
			for (String key : orderedKeys) {
				opts.add(new SelectOption(key, selectMap.get(key)));
			}
		}
		return opts;
	}

	global static List<SelectOption> createSelectList(List<SObject> sObjs, String valueField, String labelField) {
		return createSelectList(sObjs, valueField, labelField, false);
	}

	global static List<SelectOption> createSelectList(List<SObject> sObjs, SObjectField valueField, SObjectField labelField) {
		return createSelectList(sObjs, valueField + '', labelField + '', false);
	}

	global static List<SelectOption> createSelectList(List<SObject> sObjs) {
		return createSelectList(sObjs, false);
	}

	global static List<SelectOption> createSelectList(List<SObject> sObjs, Boolean blankOpt) {
		return createSelectList(sObjs, 'Id', 'Name', blankOpt);
	}

	global static void sortSelectList(List<SelectOption> opts) {
		if (opts == null) {
			return;
		}
		Integer i = 0;
		Map<String, SelectOption> mapping = new Map<String, SelectOption>();
		for (SelectOption opt : opts) {
			mapping.put(opt.getLabel() + i, opt);
		}
		List<String> sortKeys = new List<String>();
		sortKeys.addAll(mapping.keySet());
		sortKeys.sort();
		opts.clear();

		for (String key : sortKeys) {
			opts.add(mapping.get(key));
		}
	}

	global static PicklistEntry getDefaultPicklistEntry(SObjectField sfield) {
		List<PicklistEntry> entries = sfield.getDescribe().getPicklistValues();
		for (PicklistEntry entry : entries) {
			if (entry.isDefaultValue()) {
				return entry;
			}
		}
		return null;
	}

	global static String getDefaultPicklistValue(SObjectField sfield) {
		PicklistEntry ple = getDefaultPicklistEntry(sfield);
		return ple != null ? ple.getValue() : null;
	}


	/* JSON utilities
	 */





	/* Email utilities
	 */


	global static Boolean isValidEmailAddress(String str) {
		if (str != null && str.countMatches('@') == 1 && str.indexOf('@') > 0) {
			String domain = str.split('@').get(1);
			if (domain.indexOf('.') > 0 && domain.substringAfter('.').length() > 0) {
				return true;
			}
		}
		return false;
	}


	/* Trigger utilities
	 */


	global static Boolean hasFieldChanged(SObject record, String fieldName) {
		return Trigger.isInsert || record.get(fieldName) != Trigger.oldMap.get(record.Id).get(fieldName);
	}


	/* System utilities
	 */


	global static Boolean isSandbox() {
		if (isSandbox == null) {
			isSandbox = [ SELECT IsSandbox FROM Organization LIMIT 1 ].IsSandbox;
		}
		return isSandbox;
	}


	/**
	 * Reflectively check equality of given objects. If objects have no
	 * members, directly check their equality.
	 */
	global static Boolean equals(Object a, Object b) {
		if (a === b) { return true; } // *NOPAD*
		if ((a == null) ^ (b == null)) { return false; }

		Type aType = getInstanceType(a);
		Type bType = getInstanceType(b);
		if (aType != bType) {
			return false;
		}
		Map<String, Object> aMap = objectToMap(a);
		Map<String, Object> bMap = objectToMap(b);
		Set<String> aFields = aMap.keySet();
		Set<String> bFields = bMap.keySet();
		if (!aMap.isEmpty() && !bMap.isEmpty()) {
			if (aType == null && (!aFields.containsAll(bFields) || !bFields.containsAll(aFields))) {
				return false; // may occur if the class has overridden toString()
			}
			for (String field : aFields) {
				if (aMap.get(field) != bMap.get(field)) {
					return false;
				}
			}
			return true;
		}
		return a == b;
	}

	global static Type getInstanceType(Object obj) {
		Type t;
		if (obj != null) {
			String str = String.valueOf(obj);
			if (String.isNotBlank(str)) {
				t = Type.forName(str.substringBefore(':'));
			}
		}
		return t;
	}

	/**
	 * Safely generate a hashCode for a given object. If null, result is zero.
	 * @param reflective If true, generate a shallow reflective hash of all member values
	 *                   on obj. If obj has no members, result is the hash code of obj.
	 */
	global static Integer hashCode(Object obj, Boolean reflective) {
		Integer result = 0;
		if (obj != null) {
			if (reflective) {
				Map<String, Object> members = objectToMap(obj);
				if (!members.isEmpty()) {
					result = 1;
					List<String> sortedFields = new List<String>(members.keySet());
					sortedFields.sort(); // ensures fields are always iterated in the same order
					for (String field : sortedFields) {
						result = hashCode(members.get(field), result);
					}
				}
			}
			if (result == 0) {
				result = System.hashCode(obj);
			}
		}
		return result;
	}

	global static String md5(String input) {
		return EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(input)));
	}

	/**
	 * Safely generate a hashCode for a given object. If null, result is zero.
	 */
	global static Integer hashCode(Object obj) {
		return hashCode(obj, false);
	}

	global static Integer hashCode(Object obj, Integer result) {
		return HASH_PRIME * result + hashCode(obj);
	}

	global static Set<String> getClassMemberNames(Type type) {
		return objectToMap(type.newInstance()).keySet();
	}

	global static Map<String, Object> objectToMap(Object obj) {
		Map<String, Object> results;
		try {
			String jsonString = JSON.serialize(obj);
			Object deserialized = JSON.deserializeUntyped(jsonString);
			results = (Map<String, Object>) deserialized;
		}
		catch (Exception e) {
			// obj is null, has no members, or isn't an instance of a custom class
			results = new Map<String, Object>();
		}
		return results;
	}

	global static Object objectToType(Object obj, Type targetType) {
		targetType = Type.forName(targetType.toString());
		Map<String, Object> untyped = objectToMap(obj);
		Object result;
		while (result == null) {
			try {
				String jsonString = JSON.serialize(untyped);
				result = JSON.deserialize(jsonString, targetType);
				break;
			}
			catch (JSONException e) {
				String errMessage = e.getMessage();
				if (!errMessage.startsWith('Unrecognized field')) {
					throw e;
				}
				untyped.remove(errMessage.substringBetween('"'));
			}
		}
		return result;
	}

	global static Integer callerLineNumber(Integer depth) {
		Integer lineNumber;
		try {
			throw new FooException();
		}
		catch (FooException e) {
			String str = e.getStackTraceString();
			String searchStr = ': line ';
			Integer ind = ordinalIndexOf(str, searchStr, depth + 1);
			lineNumber = Integer.valueOf(str.substring(ind + searchStr.length(), str.indexOf(',', ind)));
		}
		return lineNumber;
	}

	global static void logInfo(Object obj) {
		System.debug(LoggingLevel.INFO, obj);
	}

	global static void logDebug(Object obj) {
		System.debug(LoggingLevel.DEBUG, obj);
	}

	global static void logWarning(Object obj) {
		System.debug(LoggingLevel.WARN, obj);
	}

	global static void logError(Object obj) {
		System.debug(LoggingLevel.ERROR, obj);
	}

	global static void logException(Exception e) {
		String message = e == null ? null : e.getMessage();
		System.debug(LoggingLevel.ERROR, message);
	}

	global class StopWatch {

		// running states
		final Integer STATE_UNSTARTED = 0;
		final Integer STATE_RUNNING = 1;
		final Integer STATE_STOPPED = 2;
		final Integer STATE_SUSPENDED = 3;

		// split state
		final Integer STATE_UNSPLIT = 10;
		final Integer STATE_SPLIT = 11;

		Integer runningState = STATE_UNSTARTED;
		Integer splitState = STATE_UNSPLIT;
		Long startTime = -1;
		Long stopTime = -1;

		global void start() {
			if (runningState == STATE_STOPPED) {
				throw new IllegalStateException('Stopwatch must be reset before being restarted. ');
			}
			if (runningState != STATE_UNSTARTED) {
				throw new IllegalStateException('Stopwatch already started. ');
			}
			stopTime = -1;
			startTime = System.currentTimeMillis();
			runningState = STATE_RUNNING;
		}

		global void stop() {
			if (runningState != STATE_RUNNING && runningState != STATE_SUSPENDED) {
				throw new IllegalStateException('Stopwatch is not running. ');
			}
			if (runningState == STATE_RUNNING) {
				stopTime = System.currentTimeMillis();
			}
			runningState = STATE_STOPPED;
		}

		global void reset() {
			runningState = STATE_UNSTARTED;
			splitState = STATE_UNSPLIT;
			startTime = -1;
			stopTime = -1;
		}

		global void split() {
			if (runningState != STATE_RUNNING) {
				throw new IllegalStateException('Stopwatch is not running. ');
			}
			stopTime = System.currentTimeMillis();
			splitState = STATE_SPLIT;
		}

		global void unsplit() {
			if (splitState != STATE_SPLIT) {
				throw new IllegalStateException('Stopwatch has not been split. ');
			}
			stopTime = -1;
			splitState = STATE_UNSPLIT;
		}

		global void suspend() {
			if (runningState != STATE_RUNNING) {
				throw new IllegalStateException('Stopwatch must be running to suspend. ');
			}
			stopTime = System.currentTimeMillis();
			runningState = STATE_SUSPENDED;
		}

		global void resume() {
			if (runningState != STATE_SUSPENDED) {
				throw new IllegalStateException('Stopwatch must be suspended to resume. ');
			}
			startTime += (System.currentTimeMillis() - stopTime);
			stopTime = -1;
			runningState = STATE_RUNNING;
		}

		global Long getTime() {
			if (runningState == STATE_STOPPED || runningState == STATE_SUSPENDED) {
				return stopTime - startTime;
			}
			else if (runningState == STATE_RUNNING) {
				return System.currentTimeMillis() - startTime;
			}
			return 0;
		}

		global Long getSplitTime() {
			if (splitState != STATE_SPLIT) {
				throw new IllegalStateException('Stopwatch must be split to get the split time. ');
			}
			return stopTime - startTime;
		}

		global Long getStartTime() {
			if (runningState == STATE_UNSTARTED) {
				throw new IllegalStateException('Stopwatch has not been started');
			}
			return startTime;
		}

		global String toStr() {
			return Datetime.newInstance(getTime()).format();
		}

		global String toSplitString() {
			return Datetime.newInstance(getSplitTime()).format();
		}
	}

	global class FooException extends Exception {}

	global class IllegalStateException extends Exception {}

	global class IllegalArgumentException extends Exception {}

	public static String getCreatableFieldsSOQL(String objectName, String whereClause) {
		String selects = '';
		if (whereClause == null || whereClause == '') {
			return null;
		}
		// Get a map of field name and field token
		Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().fields.getMap();
		List<String> selectFields = new List<String>();

		if (fMap != null) {
			for (Schema.SObjectField ft : fMap.values()) { // loop through all field tokens (ft)
				Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
				if (fd.isCreateable()) { // field is creatable
					selectFields.add(fd.getName());
				}
			}
		}
		if (!selectFields.isEmpty()) {
			for (string s : selectFields) {
				selects += s + ',';
			}
			if (selects.endsWith(',')) {
				selects = selects.substring(0, selects.lastIndexOf(','));
			}
		}
		return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
	}
}
