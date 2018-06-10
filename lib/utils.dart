int priceIntreg(double price) {
  return price.floor();
}

int priceDecimals(double price) {
  return ((price - price.floor()) * 100).floor();
}
