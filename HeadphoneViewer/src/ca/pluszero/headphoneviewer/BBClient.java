package ca.pluszero.headphoneviewer;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;

public class BBClient {

	private static final String BASE_URL = "http://api.remix.bestbuy.com/v1/";
	private static final String API_KEY = "q3z2rf7eskg47b78xnwqxcvq";
	private static final String SHOWN_SPECS = "sku,name,salePrice,image";
	private static AsyncHttpClient client = new AsyncHttpClient();

	// GET request with API endpoint signified by url, and params
	// other than the API key specified as a RequestParams
	public static void get(String url, RequestParams params,
			AsyncHttpResponseHandler responseHandler) {
		// Put API_KEY in params as well

		params.put("apiKey", API_KEY);
		client.get(getAbsoluteUrl(url), params, responseHandler);
	}
	
	public static void getHeadphones(AsyncHttpResponseHandler responseHandler) {
		RequestParams params = new RequestParams();
		params.put("show", SHOWN_SPECS);
		params.put("format", "json"); // ask for JSON formatted response
		params.put("pageSize", "100"); // get 100 items per page
		params.put("sort", "salePrice.dsc"); // get 100 items per page
		get("products(name=headphones*&name!=Dre*)", params, responseHandler);
	}
	
	private static String getAbsoluteUrl(String relativeUrl) {
		return BASE_URL + relativeUrl;
	}

}
