class Api {
  //* Creating instance constructor;
  static Api instance = Api();
  //* Base API URL
  // static const domain = "http://192.168.1.4/kasir-mri-api";
  // static const baseURL = domain+"/public/api";
  static const domain = "http://mri.lp2muniprima.ac.id";
  static const baseURL = domain+"/api";
  static const imageURL = domain+"/public/storage/produk_photo";

  String getUsers = "$baseURL/users";
  String loginURL = "$baseURL/login";
  String kategoriURL = "$baseURL/kategoris";
  String produkURL = "$baseURL/produk";
  String pegawaiURL = "$baseURL/pegawai";
  String stokURL = "$baseURL/stok";
  String pengeluaranURL = "$baseURL/pengeluaran";
  String transaksiURL = "$baseURL/transaksi";
  String absensiURL = "$baseURL/absensi";
}
