class EndPoints {
  EndPoints._();
  static String baseUrl = 'https://hartenaspot.net/api/';
  static String getCategories = 'v1/categories';
  static String sendFcm = 'v1/fcm-token';
  static String getAllCategories = 'v1/all-categories';
  static String getSubCategories = 'v1/categories/category/children';
  static String search = 'v1/home-search';
  static String getListing = 'v1/listings';
  static String homeSliders = 'v1/home-sliders';
  static String getCatListing = 'v1/listings-by-category';
  static String getMapListing = 'v1/listings/map';
  static String getAllUserWishes = 'v1/wishes';
  static String login = 'v1/login';
  static String register = 'v1/register';
  static String likeAndDislike = 'v1/like-toggle';
  static String updateProfile = 'v1/profile/update?_method=PUT';
  static String getLocation = 'v1/get-listing-locations';
  static String getUserProfile = 'v1/profile';
  static String getAmenities = 'v1/amenities';
  static String addListing = 'v1/listing/create';
  static String updateListing = 'v1/listing/';
  static String nearbyOffers = 'v1/offers/view';
  static String subscrip = 'v1/pay';
}
