package ca.pluszero.headphoneviewer;

import java.util.List;

import android.app.Activity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.nostra13.universalimageloader.core.ImageLoader;

public class ImageTextListAdapter extends BaseAdapter {

	private final Activity context;
	private final List<Product> products;
	private final ImageLoader imageLoader;

	public ImageTextListAdapter(Activity context, List<Product> products, ImageLoader imageLoader) {
		this.context = context;
		this.products = products;
		this.imageLoader = imageLoader;
	}

	@Override
	public View getView(int position, View view, ViewGroup parent) {
		LayoutInflater inflater = context.getLayoutInflater();
		View rowView = inflater.inflate(R.layout.row_card, null, true);
		Product product = products.get(position);
		TextView txtTitle = (TextView) rowView.findViewById(R.id.tvProductName);
		txtTitle.setText(product.getName());
		TextView txtPrice = (TextView) rowView.findViewById(R.id.tvPrice);
		txtPrice.setText("$" + product.getPrice());
		ImageView imageView = (ImageView) rowView.findViewById(R.id.ivProduct);
		imageLoader.displayImage(product.getImageUrl(), imageView);

		return rowView;
	}

	@Override
	public int getCount() {
		return products.size();
	}

	@Override
	public Object getItem(int position) {
		return products.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

}
