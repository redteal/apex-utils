@isTest
private class RT_AssertTest {

	static final RT_Assert Assert = RT_Assert.INSTANCE;

	/**
	 * Only a success of an assertion, can be tested
	 * since an assert exception cannot be caught in Apex.
	 */
	@isTest static void testAllAssertions() {
		Assert.assertTrue(true);
		Assert.assertTrue('message', true);
		Assert.assertFalse(false);
		Assert.assertFalse('message', false);
		Assert.assertEquals('foo', 'foo');
		Assert.assertEquals('message', 'foo', 'foo');
		Assert.assertNotEquals('foo', 'bar');
		Assert.assertNotEquals('message', 'foo', 'bar');
		Assert.assertNull(null);
		Assert.assertNull('message', null);
		Assert.assertNotNull('foo');
		Assert.assertNotNull('message', 'foo');

		List<String> list1 = new List<String>();
		List<String> list2 = new List<String>();

		Assert.assertSame(list1, list1);
		Assert.assertSame('message', list1, list1);
		Assert.assertNotSame(list1, list2);
		Assert.assertNotSame('message', list1, list2);
		Assert.assertBlank('');
		Assert.assertBlank('message', '');
		Assert.assertNotBlank('foo');
		Assert.assertNotBlank('message', 'foo');

		Assert.noFail = true;
		Assert.fail();
		Assert.fail('message');
	}
}
