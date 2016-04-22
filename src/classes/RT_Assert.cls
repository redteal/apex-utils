/**
 * JUnit-style assertions
 */
global class RT_Assert {

	global static final RT_Assert INSTANCE = new RT_Assert();

	@testVisible
	private Boolean noFail = false;

	global void assertTrue(Object actual) {
		System.assertEquals(true, actual);
	}

	global void assertTrue(String message, Object actual) {
		System.assertEquals(true, actual, message);
	}

	global void assertFalse(Object actual) {
		System.assertEquals(false, actual);
	}

	global void assertFalse(String message, Object actual) {
		System.assertEquals(false, actual, message);
	}

	global void assertEquals(Object expected, Object actual) {
		System.assertEquals(expected, actual);
	}

	global void assertEquals(String message, Object expected, Object actual) {
		System.assertEquals(expected, actual, message);
	}

	global void assertNotEquals(Object expected, Object actual) {
		System.assertNotEquals(expected, actual);
	}

	global void assertNotEquals(String message, Object expected, Object actual) {
		System.assertNotEquals(expected, actual, message);
	}

	global void assertNull(Object actual) {
		System.assertEquals(null, actual);
	}

	global void assertNull(String message, Object actual) {
		System.assertEquals(null, actual, message);
	}

	global void assertNotNull(Object actual) {
		System.assertNotEquals(null, actual);
	}

	global void assertNotNull(String message, Object actual) {
		System.assertNotEquals(null, actual, message);
	}

	global void assertSame(Object expected, Object actual) {
		assertSame('Expected: ' + expected + ', Actual: ' + actual, expected, actual); // *NOPAD*
	}

	global void assertSame(String message, Object expected, Object actual) {
		System.assert(expected === actual, message); // *NOPAD*
	}

	global void assertNotSame(Object expected, Object actual) {
		System.assert(expected !== actual); // *NOPAD*
	}

	global void assertNotSame(String message, Object expected, Object actual) {
		System.assert(expected !== actual, message); // *NOPAD*
	}

	global void assertBlank(String actual) {
		assertBlank('Expected blank string, got: "' + actual + '"', actual);
	}

	global void assertBlank(String message, String actual) {
		System.assert(String.isBlank(actual), message);
	}

	global void assertNotBlank(String actual) {
		assertNotBlank('Expected non-blank string, got: "' + actual + '"', actual);
	}

	global void assertNotBlank(String message, String actual) {
		System.assert(String.isNotBlank(actual), message);
	}

	global void fail() {
		System.assert(noFail ? true : false);
	}

	global void fail(String message) {
		System.assert(noFail ? true : false, message);
	}
}
