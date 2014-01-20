package ca.pluszero.headphoneviewer;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.app.SearchManager;
import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.Menu;
import android.widget.ListView;
import android.widget.SearchView;

import com.loopj.android.http.JsonHttpResponseHandler;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;

public class MainActivity extends Activity {

	private static final String BASE_URL = "http://api.remix.bestbuy.com/v1/products(name=headphones*)?show=sku,name&format=json&apiKey=";
	private static final String API_KEY = "q3z2rf7eskg47b78xnwqxcvq";
	private static final String FULL_URL = BASE_URL + API_KEY;
	private static final String DEBUG_TAG = "DEBUG_TAG";
	private static final int DELAY_FEED_RETRIEVE = 3000;
	private static final String SEARCH_KEY= "keySearch";
	Context context = this;
	private ListView lvHeadphonesList;
	private List<Product> products;
	ImageTextListAdapter headphonesAdapter;

	Handler timerHandler = new Handler();
	Runnable timerRunnable = new Runnable() {

		@Override
		public void run() {
			// Add this runnable to message queue to be run after
			// DELAY_FEED_RETRIEVE ms
			timerHandler.postDelayed(this, DELAY_FEED_RETRIEVE);
			getBBDataWithLibrary();
			// getBBDataWithAsyncTasks();
			headphonesAdapter.notifyDataSetChanged();
		}

	};

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);

		// Set up image cacher/retriever
		DisplayImageOptions defaultOptions = new DisplayImageOptions.Builder().cacheInMemory(true)
				.cacheOnDisc(true).build();
		ImageLoaderConfiguration config = new ImageLoaderConfiguration.Builder(
				getApplicationContext()).defaultDisplayImageOptions(defaultOptions).build();
		ImageLoader.getInstance().init(config);
		
		
		// Instantiate views
		lvHeadphonesList = (ListView) findViewById(R.id.lvHeadphones);
		products = new ArrayList<Product>();
		headphonesAdapter = new ImageTextListAdapter(this, products, ImageLoader.getInstance());
		lvHeadphonesList.setAdapter(headphonesAdapter);

		// add runnable to the message queue to occur immediately
		timerHandler.postDelayed(timerRunnable, 0);
		
	}
	
	private void searchQuery(String query) {
		List<Product> newProducts = new ArrayList<Product>();
		for (Product product : products) {
			if (product.getName().toLowerCase(Locale.ENGLISH).contains(query.toLowerCase(Locale.ENGLISH))) {
				newProducts.add(product);
			}
		}
		headphonesAdapter = new ImageTextListAdapter(this, newProducts, ImageLoader.getInstance());
		lvHeadphonesList.setAdapter(headphonesAdapter);
	}
	
	@Override
	public boolean onSearchRequested() {
	     Bundle appData = new Bundle();
	     appData.putBoolean(MainActivity.SEARCH_KEY, true);
	     startSearch(null, false, appData, false);
	     return true;
	 }

	private void getBBDataWithLibrary() {
		// Check if user has internet connection
		ConnectivityManager connMgr = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo networkInfo = connMgr.getActiveNetworkInfo();
		if (networkInfo != null && networkInfo.isConnected()) {
			BBClient.getHeadphones(new JsonHttpResponseHandler() {
				@Override
				public void onStart() {
				}

				@Override
				public void onSuccess(JSONObject response) {
					try {
						JSONArray jsonProducts = response.getJSONArray("products");
						// Clear all items in listview backed by products list
						products.clear();
						headphonesAdapter.notifyDataSetChanged();

						// Retrieve each JSON product and turn it into a Product
						for (int i = 0; i < jsonProducts.length(); i++) {
							JSONObject jsonProduct = jsonProducts.getJSONObject(i);
							String productName = jsonProduct.getString("name");
							double salePrice = jsonProduct.getDouble("salePrice");
							String imageUrl = jsonProduct.getString("image");
							Product product = new Product(productName, salePrice, imageUrl);
							products.add(product);
							Log.d("DEBUG_TAG", productName + "salePrice: " + salePrice
									+ "imageUrl: " + imageUrl);
						}
						headphonesAdapter.notifyDataSetChanged();
						// remove this runnable from handler's message queue
						timerHandler.removeCallbacks(timerRunnable);
					} catch (JSONException e) {
						Log.d(DEBUG_TAG, "failed to get products JSON array from response body");
					}
				}
			});
		} else {
			Log.d(DEBUG_TAG, "User has no internet connection.");
		}
	}

	private void getBBDataWithAsyncTasks() {
		// Check if user has internet connection
		ConnectivityManager connMgr = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo networkInfo = connMgr.getActiveNetworkInfo();
		if (networkInfo != null && networkInfo.isConnected()) {
			new GetBBFeedTask().execute(FULL_URL);
		} else {
			Log.d(DEBUG_TAG, "User has no internet connection.");
		}
	}

	private class GetBBFeedTask extends AsyncTask<String, Void, String> {

		@Override
		protected String doInBackground(String... urls) {
			try {
				String responseBody = downloadUrl(urls[0]);
				Log.d(DEBUG_TAG, responseBody);
				return responseBody;
			} catch (IOException e) {
				return "Failed to process input stream";
			}
		}
	}

	private String downloadUrl(String myurl) throws IOException {
		InputStream is = null;
		// Only display the first 10 000 characters of the retrieved
		// web page content.
		int len = 10000;

		try {
			URL url = new URL(myurl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setReadTimeout(10000 /* milliseconds */);
			conn.setConnectTimeout(15000 /* milliseconds */);
			conn.setRequestMethod("GET");
			conn.setDoInput(true);
			// Starts the query
			conn.connect();
			int response = conn.getResponseCode();
			Log.d("DEBUG_TAG", "The response is: " + response);
			is = conn.getInputStream();

			// Convert the InputStream into a string
			String contentAsString = readIt(is, len);
			return contentAsString;

			// Makes sure that the InputStream is closed after the app is
			// finished using it.
		} finally {
			if (is != null) {
				is.close();
			}
		}
	}

	// Reads an InputStream and converts it to a String.
	public String readIt(InputStream stream, int len) throws IOException,
			UnsupportedEncodingException {
		Reader reader = null;
		reader = new InputStreamReader(stream, "UTF-8");
		char[] buffer = new char[len];
		reader.read(buffer);
		return new String(buffer);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		 // Get the SearchView and set the searchable configuration
	    SearchManager searchManager = (SearchManager) getSystemService(Context.SEARCH_SERVICE);
	    SearchView searchView = (SearchView) menu.findItem(R.id.action_search).getActionView();
	    // Assumes current activity is the searchable activity
	    searchView.setSearchableInfo(searchManager.getSearchableInfo(getComponentName()));
	    searchView.setIconifiedByDefault(false);
	    searchView.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
			
			@Override
			public boolean onQueryTextSubmit(String query) {
				searchQuery(query);
				return false;
			}
			
			@Override
			public boolean onQueryTextChange(String newText) {
				searchQuery(newText);
				return false;
			}
		});
		return true;
	}
	
//	@Override
//	public boolean onOptionsItemSelected(MenuItem item) {
//		// Handle presses on the action bar items
//		
//		switch (item.getItemId()) {
//		case R.id.action_search:
//			openSearch();
//			return true;
//		default:
//			return super.onOptionsItemSelected(item);
//		}
//		
//	}

}
