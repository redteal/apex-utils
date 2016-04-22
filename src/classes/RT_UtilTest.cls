@isTest
private class RT_UtilTest {

	static final RT_Assert Assert = RT_Assert.INSTANCE;

	/*****************************
	 * String utilities
	 */

	@isTest static void testFormat() {
		String format, expected, actual;
		Object obj;

		format = ' a{0}c{1}e ';
		obj = new List<String> {'b', 'd'};
		expected = ' abcde ';
		actual = RT_Util.format(format, obj);
		Assert.assertEquals(expected, actual);

		format = ' x{0}yz ';
		obj = 1;
		expected = ' x1yz ';
		actual = RT_Util.format(format, obj);
		Assert.assertEquals(expected, actual);

		format = null;
		obj = null;
		expected = '';
		actual = RT_Util.format(format, obj);
		Assert.assertEquals(expected, actual);
	}

	@isTest static void testExplode() {
		String str = 'foobar';
		List<String> exploded = RT_Util.explode(str);
		Assert.assertEquals(str.length(), exploded.size());
		Assert.assertEquals('f', exploded.get(0));
		Assert.assertEquals('o', exploded.get(1));
		Assert.assertEquals('o', exploded.get(2));
		Assert.assertEquals('b', exploded.get(3));
		Assert.assertEquals('a', exploded.get(4));
		Assert.assertEquals('r', exploded.get(5));
	}

	@isTest static void testOrdinalIndexOf() {
		String str, searchStr;
		Integer ordinal, result;

		str = 'abcdefgabcdefgabcdefgabcdefg';
		searchStr = 'def';
		ordinal = 3;
		result = RT_Util.ordinalIndexOf(str, searchStr, ordinal);
		Assert.assertEquals(17, result);

		ordinal = 0;
		result = RT_Util.ordinalIndexOf(str, searchStr, ordinal);
		Assert.assertEquals(-1, result);

		ordinal = 1;
		searchStr = '';
		result = RT_Util.ordinalIndexOf(str, searchStr, ordinal);
		Assert.assertEquals(str.length(), result);

		ordinal = 2;
		searchStr = 'gab';
		result = RT_Util.ordinalIndexOf(str, searchStr, ordinal);
		Assert.assertEquals(13, result);

		searchStr = 'x';
		result = RT_Util.ordinalIndexOf(str, searchStr, ordinal);
		Assert.assertEquals(-1, result);
	}

	@isTest static void testConvertLineEndings() {
		String str = '\rfoo\r\nbar\rfoo\nbar\r\n';
		String result = RT_Util.convertLineEndings(str);
		Assert.assertEquals('\nfoo\nbar\nfoo\nbar\n', result);
	}

	@isTest static void testSubstring() {
		Integer startIndex, endIndex;
		String str, expected, actual;

		str = 'test string';
		startIndex = 5;
		endIndex = 3;
		expected = '';
		actual = RT_Util.substring(str, startIndex, endIndex);
		Assert.assertEquals(expected, actual);

		str = 'test string';
		startIndex = null;
		expected = 'test string';
		actual = RT_Util.substring(str, startIndex);
		Assert.assertEquals(expected, actual);
	}

	@isTest static void testRemoveWhitespace() {
		String str, expected, actual;

		str = '    \n  ';
		expected = '';
		actual = RT_Util.normalizeSpace(str);
		Assert.assertEquals(expected, actual);

		str = '    t    e s    t  ';
		expected = 't e s t';
		actual = RT_Util.normalizeSpace(str);
		Assert.assertEquals(expected, actual);
	}

	@isTest static void testLowerCase() {
		String str = 'Test String';
		String expected = 'test string';
		String actual = RT_Util.lowerCase(str);
		Assert.assertEquals(expected, actual);
	}

	@isTest static void testUpperCase() {
		String str = 'Test String';
		String expected = 'TEST STRING';
		String actual = RT_Util.upperCase(str);
		Assert.assertEquals(expected, actual);
	}

	/*****************************
	 * Number utilities
	 */

	@isTest static void testIsNullOrZero() {
		Object a = null, b = 0, c = 1, d = -1;
		Assert.assertTrue(RT_Util.isNullOrZero(a));
		Assert.assertTrue(RT_Util.isNullOrZero(b));
		Assert.assertFalse(RT_Util.isNullOrZero(c));
		Assert.assertFalse(RT_Util.isNullOrZero(d));
	}

	@isTest static void testIsNaN() {
		Object a = 1, b = null, c = 2L, d = '@', e = Double.valueOf(4), f = 2.2;
		Assert.assertFalse(RT_Util.isNaN(a));
		Assert.assertTrue(RT_Util.isNaN(b));
		Assert.assertFalse(RT_Util.isNaN(c));
		Assert.assertTrue(RT_Util.isNaN(d));
		Assert.assertFalse(RT_Util.isNaN(e));
		Assert.assertFalse(RT_Util.isNaN(f));
	}

	@isTest static void testRandomInt() {
		Integer max = 2;
		Set<Integer> results = new Set<Integer>();
		for (Integer i = 0; i < 500; i++) {
			results.add(RT_Util.randomInt(max));
		}
		Assert.assertEquals(3, results.size());
		Assert.assertTrue(results.contains(0));
		Assert.assertTrue(results.contains(1));
		Assert.assertTrue(results.contains(2));
	}

	@isTest static void testCompare() {
		Object a = 1, b = 2;
		Assert.assertEquals(-1, RT_Util.compare(a, b));
		Assert.assertEquals(1, RT_Util.compare(b, a));
		a = 2;
		Assert.assertEquals(0, RT_Util.compare(a, b));
		a = Date.today();
		b = Date.today();
		Assert.assertEquals(0, RT_Util.compare(a, b));
		a = ((Date) a).addDays(1);
		Assert.assertEquals(1, RT_Util.compare(a, b));
		Assert.assertEquals(-1, RT_Util.compare(b, a));
	}

	@isTest static void testToDouble() {
		Object o = 1;
		Assert.assertEquals(1.0, RT_Util.toDouble(o));
		o = true;
		Assert.assertEquals(1.0, RT_Util.toDouble(o));
		o = false;
		Assert.assertEquals(0.0, RT_Util.toDouble(o));
		o = null;
		Assert.assertEquals(0.0, RT_Util.toDouble(o));
		o = null;
		Assert.assertEquals(1.0, RT_Util.toDouble(o, Double.valueOf(1)));
		o = new Foo();
		Assert.assertEquals(1.0, RT_Util.toDouble(o, Double.valueOf(1)));
		o = 'foo';
		Assert.assertEquals(1.0, RT_Util.toDouble(o, Double.valueOf(1)));
		o = '1.5';
		Assert.assertEquals(1.5, RT_Util.toDouble(o));
	}

	@isTest static void testToDecimal() {
		Object o = 1;
		Assert.assertEquals(1.0, RT_Util.toDecimal(o));
		o = true;
		Assert.assertEquals(1.0, RT_Util.toDecimal(o));
		o = false;
		Assert.assertEquals(0.0, RT_Util.toDecimal(o));
		o = null;
		Assert.assertEquals(0.0, RT_Util.toDecimal(o));
		o = null;
		Assert.assertEquals(1.0, RT_Util.toDecimal(o, 1));
		o = new Foo();
		Assert.assertEquals(1.0, RT_Util.toDecimal(o, 1.0));
		o = 'foo';
		Assert.assertEquals(1.0, RT_Util.toDecimal(o, 1.0));
		o = '1.5';
		Assert.assertEquals(1.5, RT_Util.toDecimal(o));

	}

	@isTest static void testToInteger() {
		Object o = 1;
		Assert.assertEquals(1, RT_Util.toInteger(o));
		o = ((Long) RT_Util.MAX_INTEGER) + 1L;
		Assert.assertEquals(RT_Util.MAX_INTEGER, RT_Util.toInteger(o));
		o = true;
		Assert.assertEquals(1, RT_Util.toInteger(o));
		o = false;
		Assert.assertEquals(0, RT_Util.toInteger(o));
		o = null;
		Assert.assertEquals(0, RT_Util.toInteger(o));
		o = null;
		Assert.assertEquals(1, RT_Util.toInteger(o, 1));
		o = new Foo();
		Assert.assertEquals(1, RT_Util.toInteger(o, 1));
		o = 'foo';
		Assert.assertEquals(1, RT_Util.toInteger(o, 1));
		o = '1.5';
		Assert.assertEquals(1, RT_Util.toInteger(o));

	}

	@isTest static void testToLong() {
		Object o = 1;
		Assert.assertEquals(1L, RT_Util.toLong(o));
		o = ((Long) RT_Util.MAX_INTEGER) + 1L;
		Assert.assertEquals(((Long) RT_Util.MAX_INTEGER) + 1L, RT_Util.toLong(o));
		o = true;
		Assert.assertEquals(1L, RT_Util.toLong(o));
		o = false;
		Assert.assertEquals(0L, RT_Util.toLong(o));
		o = null;
		Assert.assertEquals(0L, RT_Util.toLong(o));
		o = null;
		Assert.assertEquals(1L, RT_Util.toLong(o, 1L));
		o = new Foo();
		Assert.assertEquals(1L, RT_Util.toLong(o, 1L));
		o = 'foo';
		Assert.assertEquals(1L, RT_Util.toLong(o, 1L));
		o = '1.5';
		Assert.assertEquals(1L, RT_Util.toLong(o));
	}

	@isTest static void testInIntRange() {
		Assert.assertTrue(RT_Util.inIntRange((Long) RT_Util.MAX_INTEGER));
		Assert.assertTrue(RT_Util.inIntRange((Long) RT_Util.MIN_INTEGER));
		Assert.assertFalse(RT_Util.inIntRange(((Long) RT_Util.MAX_INTEGER) + 1L));
		Assert.assertFalse(RT_Util.inIntRange(((Long) RT_Util.MIN_INTEGER) - 1L));
	}

	/*****************************
	 * Date/DateTime utilities
	 */

	@isTest static void testToDate() {
		Assert.assertEquals(Date.today(), RT_Util.toDate(Date.today().format()));
		Assert.assertNull(RT_Util.toDate(null));
		Assert.assertEquals(Date.today(), RT_Util.toDate(Date.today()));
		Assert.assertEquals(Date.today(), RT_Util.toDate(DateTime.now()));
		Assert.assertNull(RT_Util.toDate('foo'));
	}


	/*****************************
	 * Boolean utilities
	 */

	@isTest static void testToBoolean() {
		Object t = 'true', f = 'false', foo = 'foo';
		Assert.assertTrue(RT_Util.toBoolean(t));
		Assert.assertFalse(RT_Util.toBoolean(f));
		Assert.assertFalse(RT_Util.toBoolean(foo));
		Assert.assertNull(RT_Util.toBoolean(null));
	}

	/*****************************
	 * Array utilities
	 */

	@isTest static void testFirst() {
		List<Object> lst = new List<Object> {'a', 'b', 'c'};
		Assert.assertEquals('a', RT_Util.first(lst));
	}

	// Also tests isEmpty
	@isTest static void testIsNotEmpty() {
		List<Object> lst = new List<Object> {'a', 'b', 'c'};
		List<SObject> lst2 = new List<SObject>();
		Assert.assertTrue(RT_Util.isNotEmpty(lst));
		Assert.assertFalse(RT_Util.isNotEmpty(lst2));
	}

	@isTest static void testPluck() {
		List<SObject> sObjs = new List<SObject>();
		sObjs.add(new Foo__c(A__c = 1));
		sObjs.add(new Foo__c(A__c = 2));
		sObjs.add(new Foo__c(A__c = 3));
		List<Object> names = RT_Util.pluck(sObjs, '' + Foo__c.A__c);
		Assert.assertEquals(1, names.get(0));
		Assert.assertEquals(2, names.get(1));
		Assert.assertEquals(3, names.get(2));
		Assert.assertEquals(0, RT_Util.pluck(new List<SObject>(), '').size());
	}

	@isTest static void testToLowerCase() {
		List<String> stringList = new List<String> {'Cat', 'DOG', 'Narwhal'};
		List<String> lowercasedList = RT_Util.toLowerCase(stringList);
		Set<String> stringSet = new Set<String> {'Cat', 'DOG', 'Narwhal'};
		Set<String> lowercasedSet = RT_Util.toLowerCase(stringSet);

		Assert.assertEquals(3, lowercasedList.size());
		Assert.assertEquals('cat', lowercasedList.get(0));
		Assert.assertEquals('dog', lowercasedList.get(1));
		Assert.assertEquals('narwhal', lowercasedList.get(2));
		Assert.assertEquals(3, lowercasedSet.size());
		Assert.assertTrue(lowercasedSet.contains('cat'));
		Assert.assertTrue(lowercasedSet.contains('dog'));
		Assert.assertTrue(lowercasedSet.contains('narwhal'));
	}

	@isTest static void testFlatten() {
		List<Object> objs;
		Assert.assertNull(RT_Util.flatten(objs));
		objs = new List<Object>();
		Assert.assertEquals(0, RT_Util.flatten(objs).size());
		objs.add(0);
		objs.add(new List<Object> {0, new List<Object> {0, new List<Object> {0}}});
		objs.add(0);
		objs.add(new List<Object> {0});
		Assert.assertEquals(6, RT_Util.flatten(objs).size());
	}

	@isTest static void testIndexOf() {
		List<String> strings = new List<String> {'cat', 'dog', 'narwhal'};
		Assert.assertEquals(-1, RT_Util.indexOf(strings, 'foo'));
		Assert.assertEquals(0, RT_Util.indexOf(strings, 'cat'));
		Assert.assertEquals(1, RT_Util.indexOf(strings, 'dog'));
		Assert.assertEquals(2, RT_Util.indexOf(strings, 'narwhal'));
	}

	@isTest static void testBinarySearch() {
		List<String> strings = new List<String> {'cat', 'dog', 'narwhal'};
		Assert.assertEquals(-1, RT_Util.binarySearch(strings, 'foo'));
		Assert.assertEquals(0, RT_Util.binarySearch(strings, 'cat'));
		Assert.assertEquals(1, RT_Util.binarySearch(strings, 'dog'));
		Assert.assertEquals(2, RT_Util.binarySearch(strings, 'narwhal'));
	}


	/*****************************
	 * Set utilities
	 */


	@isTest static void testSampleStrings() {
		Set<String> strings = new Set<String> {'cat', 'dog', 'narwhal'};
		Assert.assertTrue(strings.contains(RT_Util.sampleStrings(strings)));
	}

	@isTest static void testJoin() {
		Set<String> strings = new Set<String> {'a', 'b', 'c'};
		Assert.assertTrue(RT_Util.join(strings, ',').containsOnly('abc,'));
		Assert.assertTrue(RT_Util.join(strings, null).containsOnly('abc'));

		insert new Foo__c();
		insert new Foo__c();

		Set<Id> ids = new Set<Id>();
		List<Object> idList = RT_Util.pluck([ SELECT Id FROM Foo__c LIMIT 2 ], 'Id');
		for (Object id : idList) {
			ids.add((Id) id);
		}
		Assert.assertTrue(RT_Util.join(ids, null).contains(String.valueOf(idList.get(0))));
		Assert.assertTrue(RT_Util.join(ids, null).contains(String.valueOf(idList.get(1))));
	}

	@isTest static void testContainsIgnoreCase() {
		Set<String> strings = new Set<String> {'a', 'B', 'c'};
		Assert.assertTrue(RT_Util.containsIgnoreCase(strings, 'A'));
		Assert.assertTrue(RT_Util.containsIgnoreCase(strings, 'b'));
		Assert.assertTrue(RT_Util.containsIgnoreCase(strings, 'c'));
		Assert.assertFalse(RT_Util.containsIgnoreCase(strings, 'd'));
	}

	/*****************************
	 * SOQL utilities
	 */

	@isTest static void testGetBaseQuery() {
		SObjectType stype = Foo__c.sObjectType;
		Assert.assertTrue(RT_Util.getBaseQuery(stype).endsWith(' FROM ' + stype));
		Assert.assertTrue(RT_Util.getBaseQuery(stype, 'Id!=null').endsWith('FROM ' + stype + ' WHERE ' + Foo__c.Id + '!=null'));

		Map<String, ChildRelationship> childRels = RT_Util.getChildRelationships(Foo__c.sObjectType);
		String barsRelName;
		for (ChildRelationship childRel : childRels.values()) {
			if (childRel.getChildSObject() == Bar__c.sObjectType) {
				barsRelName = childRel.getRelationshipName();
			}
		}
		String baseBarQuery = RT_Util.getBaseQuery(stype, new Set<String> {barsRelName}, null);
		Assert.assertTrue(baseBarQuery.contains(' FROM ' + barsRelName + ')'));
		Assert.assertTrue(baseBarQuery.endsWith(' FROM ' + stype));
	}

	@isTest static void testFindSObjects() {
		Foo__c foo1 = new Foo__c();
		insert foo1;
		Foo__c foo2 = new Foo__c();
		insert foo2;
		SObjectType stype = Foo__c.sObjectType;
		Set<Id> ids = new Set<Id> {foo1.Id, foo2.Id};
		Assert.assertNotNull(RT_Util.findSObject(stype, foo1.Id));
		Assert.assertTrue(RT_Util.findSObjects(stype, null).isEmpty());
		Assert.assertEquals(2, RT_Util.findSObjects(stype, ids).size());
	}

	@isTest static void testGetReferenceValues() {
		Foo__c foo = new Foo__c(Color__c = 'Blue');
		insert foo;
		Bar__c bar1 = new Bar__c(Foo__c = foo.Id);
		insert bar1;
		Bar__c bar2 = new Bar__c(Foo__c = foo.Id);
		insert bar2;
		bar1 = [ SELECT Foo__r.Color__c FROM Bar__c WHERE Id = :bar1.Id ];
		bar2 = [ SELECT Foo__r.Color__c FROM Bar__c WHERE Id = :bar2.Id ];

		Test.startTest();
		String fieldName = Bar__c.Foo__c.getDescribe().getRelationshipName() + '.' + Foo__c.Color__c;
		Set<String> fields = new Set<String> {fieldName};
		Assert.assertEquals('Blue', RT_Util.getReferenceValue(fieldName, bar1));
		Assert.assertEquals('Blue', RT_Util.getReferenceValues(fields, bar2, null).get(fieldName));
		Assert.assertEquals('\'Blue\'', RT_Util.getReferenceValue(fieldName, bar1, true));
		Assert.assertEquals('Blue', RT_Util.getReferenceValues(fields, bar2).get(fieldName));
		Test.stopTest();
	}

	@isTest static void testGetCommaSeparatedFields() {
		SObjectType sObjectType;
		String expected, actual;

		expected = null;
		actual = RT_Util.getCommaSeparatedFields(sObjectType);
		Assert.assertEquals(expected, actual);

		sObjectType = Lead.sObjectType;
		actual = RT_Util.getCommaSeparatedFields(sObjectType);
		Assert.assertTrue(String.isNotBlank(actual));
		Assert.assertTrue(actual.contains('id'));
		Assert.assertTrue(actual.contains(','));
		Assert.assertNotEquals(actual.indexOf(','), 0);
		Assert.assertNotEquals(actual.lastIndexOf(','), actual.length() - 1);
	}

	/*****************************
	 * Schema describe utilities
	 */

	@isTest static void testGetSObjectType() {
		Assert.assertEquals(Foo__c.sObjectType, RT_Util.getSObjectType('' + Foo__c.sObjectType));
	}

	@isTest static void testSObjectTypeName() {
		Foo__c foo = new Foo__c();
		insert foo;
		Bar__c bar = new Bar__c(Foo__c = foo.Id);
		insert bar;

		String fooStr = '' + Foo__c.sObjectType;
		String barStr = '' + Bar__c.sObjectType;

		Assert.assertNull(RT_Util.sObjectTypeName((SObject) null));
		Assert.assertEquals(fooStr, RT_Util.sObjectTypeName(foo));

		Assert.assertNull(RT_Util.sObjectTypeName((Id) null));
		Assert.assertEquals(fooStr, RT_Util.sObjectTypeName(foo.Id));

		Assert.assertNull(RT_Util.sObjectTypeName((SObjectType) null));
		Assert.assertEquals(fooStr, RT_Util.sObjectTypeName(Foo__c.sObjectType));

		Set<String> expectedNames = new Set<String> {fooStr, barStr};

		Assert.assertNull(RT_Util.sObjectTypeNames((List<SObject>) null));
		Assert.assertEquals(expectedNames, RT_Util.sObjectTypeNames(new List<SObject> {foo, bar, null}));

		Assert.assertNull(RT_Util.sObjectTypeNames((List<Id>) null));
		Assert.assertEquals(expectedNames, RT_Util.sObjectTypeNames(new List<Id> {foo.Id, bar.Id, null}));
	}

	@isTest static void testGlobalSchema() {
		Map<String, SObjectType> gd = Schema.getGlobalDescribe();

		// assure ourselves that global describe map lookups are case-insensitive.
		Assert.assertTrue(gd.containsKey('' + Foo__c.sObjectType));
		Assert.assertTrue(gd.containsKey(('' + Foo__c.sObjectType).toLowerCase()));
		Assert.assertTrue(gd.containsKey(('' + Foo__c.sObjectType).toUpperCase()));
		Assert.assertSame(Foo__c.sObjectType, gd.get('' + Foo__c.sObjectType));
		Assert.assertSame(Foo__c.sObjectType, gd.get(('' + Foo__c.sObjectType).toLowerCase()));
		Assert.assertSame(Foo__c.sObjectType, gd.get(('' + Foo__c.sObjectType).toUpperCase()));
	}

	@isTest static void testSObjectDescribe() {
		Assert.assertEquals(Foo__c.sObjectType.getDescribe(), RT_Util.getDescribe('' + Foo__c.sObjectType));
	}

	@isTest static void testFieldDescribe() {
		Assert.assertEquals(Foo__c.Name.getDescribe(), RT_Util.getDescribe('' + Foo__c.sObjectType, '' + Foo__c.Name));
	}

	@isTest static void testSObjectFieldMethods() {
		SObjectType sObjectType = Foo__c.sObjectType;
		Assert.assertTrue(!RT_Util.sObjectFieldNames(sObjectType).isEmpty());
		Assert.assertTrue(!RT_Util.sObjectFieldNames(RT_Util.sObjectTypeName(sObjectType)).isEmpty());
		Assert.assertTrue(!RT_Util.sObjectFields(sObjectType).isEmpty());
		Assert.assertTrue(!RT_Util.sObjectFields(RT_Util.sObjectTypeName(sObjectType)).isEmpty());
	}

	@isTest static void testGetDisplayType() {
		Assert.assertEquals(DisplayType.ID, RT_Util.getDisplayType('' + Foo__c.sObjectType, '' + Foo__c.Id));
		Assert.assertEquals(DisplayType.ID, RT_Util.getDisplayType(Foo__c.Id));
	}

	@isTest static void testGetAllActiveRecordTypeIds() {
		SObjectType stype = Foo__c.sObjectType;
		List<RecordType> rtypes = [ SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = :('' + stype) AND IsActive = true ];

		Map<String, Id> expected = new Map<String, Id>();
		Map<String, Id> actual = RT_Util.getRecordTypeIds(stype);
		for (RecordType rt : rtypes) {
			Assert.assertTrue(actual.containsKey(rt.DeveloperName));
			expected.put(rt.DeveloperName, rt.Id);
		}
		Assert.assertEquals(expected, actual);

		actual = RT_Util.getRecordTypeIds(stype, (Boolean) null); // availableOnly should default to false
		Assert.assertEquals(expected, actual);
	}

	@isTest static void testGetAvailableActiveRecordTypeIds() {
		SObjectType stype = Foo__c.sObjectType;
		List<RecordType> rtypes = [ SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = :('' + stype) AND IsActive = true ];

		Map<Id, RecordTypeInfo> rtypeInfos = stype.getDescribe().getRecordTypeInfosByID();
		Map<String, Id> expected = new Map<String, Id>();
		Map<String, Id> actual = RT_Util.getRecordTypeIds(stype, true);
		for (RecordType rt : rtypes) {
			// verify that the results contain only user-available record types
			Boolean isAvailable = rtypeInfos.get(rt.Id).isAvailable();
			Assert.assertEquals(isAvailable, actual.containsKey(rt.DeveloperName));
			if (isAvailable) {
				expected.put(rt.DeveloperName, rt.Id);
			}
		}
		Assert.assertEquals(expected, actual);
	}

	@isTest static void testGetRecordTypeId() {
		SObjectType stype = Foo__c.sObjectType;
		List<RecordType> rtypes = [ SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = :('' + stype) AND IsActive = true ];
		RecordType rt = rtypes.get(0);
		Assert.assertEquals(rt.Id, RT_Util.getRecordTypeId('' + stype, rt.DeveloperName));
	}

	@isTest static void testGetRecordTypeIdByName() {
		SObjectType stype = Foo__c.sObjectType;
		List<RecordType> rtypes = [ SELECT Id, Name FROM RecordType WHERE SObjectType = :('' + stype) AND IsActive = true ];
		RecordType rt = rtypes.get(0);
		Assert.assertEquals(rt.Id, RT_Util.getRecordTypeIdByName('' + stype, rt.Name));
	}

	/*****************************
	 * System utilities
	 */

	@isTest static void testGetClassMemberNames() {
		Type type;
		Set<String> expected, actual;

		type = TestInner1.class;
		expected = new Set<String> {'x', 'y'};
		actual = RT_Util.getClassMemberNames(type);
		Assert.assertTrue(actual.containsAll(expected));
	}

	@isTest static void testObjectToMap() {
		Object obj;
		Map<String, Object> expected, actual;

		obj = 'test';
		expected = new Map<String, Object>();
		actual = RT_Util.objectToMap(obj);
		Assert.assertEquals(expected, actual);

		obj = new TestInner1();
		((TestInner1)obj).x = 1;
		((TestInner1)obj).y = 2;
		expected = new Map<String, Object> {'x' => 1, 'y' => 2};
		actual = RT_Util.objectToMap(obj);
		Assert.assertEquals(expected, actual);
	}

	@isTest static void testGetInstanceType() {
		Object obj;
		Type expected, actual;

		obj = new RT_Util();
		expected = RT_Util.class;
		actual = RT_Util.getInstanceType(obj);
		Assert.assertEquals(expected, actual);
	}

	@isTest static void testEquals() {
		Object obj1, obj2;
		Boolean actual;

		obj1 = new TestInner1();
		((TestInner1)obj1).x = 1;
		((TestInner1)obj1).y = 1;
		obj2 = new TestInner1();
		((TestInner1)obj2).x = 1;
		((TestInner1)obj2).y = 3;
		actual = RT_Util.equals(obj1, obj2);
		Assert.assertTrue(!actual);

		((TestInner1)obj1).y = 3;
		actual = RT_Util.equals(obj1, obj2);
		Assert.assertTrue(actual);

		obj1 = new TestInner1();
		obj2 = new TestInner2();
		actual = RT_Util.equals(obj1, obj2);
		Assert.assertTrue(!actual);

		obj2 = new RT_Util();
		actual = RT_Util.equals(obj1, obj2);
		Assert.assertTrue(!actual);

		obj2 = null;
		actual = RT_Util.equals(obj1, obj2);
		Assert.assertTrue(!actual);

		obj1 = 2;
		obj2 = 2;
		actual = RT_Util.equals(obj1, obj2);
		Assert.assertTrue(actual);

		obj1 = null;
		obj2 = null;
		actual = RT_Util.equals(obj1, obj2);
		Assert.assertTrue(actual);

		obj1 = 1;
		obj2 = 2;
		actual = RT_Util.equals(obj1, obj2);
		Assert.assertTrue(!actual);
	}

	@isTest static void testHashCode() {
		TestInner1 obj;
		Integer expected, actual;

		obj = new TestInner1();
		obj.x = 3;
		obj.y = 5;
		expected = 1;
		expected = RT_Util.HASH_PRIME * expected + System.hashCode(3);
		expected = RT_Util.HASH_PRIME * expected + System.hashCode(5);
		actual = RT_Util.hashCode(obj, true);
		Assert.assertEquals(expected, actual);
	}

	@isTest static void testLog() {
		RT_Util.logInfo(null);
		RT_Util.logDebug(null);
		RT_Util.logWarning(null);
		RT_Util.logError(null);
		RT_Util.logException(null);
	}

	@isTest static void testPageRef() {
		Foo__c foo = new Foo__c();
		insert foo;

		PageReference ref = new PageReference('/'+ foo.Id);
		ref.setRedirect(true);

		SObject nullRecord = null;
		RT_Util.pageRef(nullRecord);
		RT_Util.pageRef(foo, 'edit', false);
		RT_Util.pageRef(foo, 'cancel');
		RT_Util.pageRef(foo);
		RT_Util.pageRef(foo.Id, 'save', true);
		RT_Util.pageRef(foo.Id, 'delete');
		RT_Util.pageRef(foo.Id);
		RT_Util.pageRef('/' + foo.Id, true);
		RT_Util.pageRef('/' + foo.Id);
	}

	@isTest static void testStopwatch() {
		RT_Util.Stopwatch stopwatch = new RT_Util.StopWatch();
		stopwatch.getTime();
		try {
			stopwatch.stop();
			Assert.fail();
		}
		catch (RT_Util.IllegalStateException e) {}
		try {
			stopwatch.getStartTime();
			Assert.fail();
		}
		catch (RT_Util.IllegalStateException e) {}
		stopwatch.start();
		stopwatch.getStartTime();
		try {
			stopwatch.start();
			Assert.fail();
		}
		catch (RT_Util.IllegalStateException e) {}
		stopwatch.getTime();
		stopwatch.stop();
		stopwatch.toStr();
		try {
			stopwatch.start();
			Assert.fail();
		}
		catch (RT_Util.IllegalStateException e) {}
		try {
			stopwatch.split();
			Assert.fail();
		}
		catch (RT_Util.IllegalStateException e) {}
		try {
			stopwatch.unsplit();
			Assert.fail();
		}
		catch (RT_Util.IllegalStateException e) {}
		stopwatch.reset();
		try {
			stopwatch.suspend();
			Assert.fail();
		}
		catch (RT_Util.IllegalStateException e) {}
		try {
			stopwatch.resume();
			Assert.fail();
		}
		catch (RT_Util.IllegalStateException e) {}
		stopwatch.start();
		try {
			stopwatch.getSplitTime();
			Assert.fail();
		}
		catch (RT_Util.IllegalStateException e) {}
		stopwatch.split();
		stopwatch.toSplitString();
		stopwatch.unsplit();
		stopwatch.suspend();
		stopwatch.resume();
	}

	public class TestInner1 {
		public Integer x;
		public Integer y;
	}

	public class TestInner2 {
		public Integer x;
		public Integer y;
		public Integer z;
	}

	public class Foo {}
}
