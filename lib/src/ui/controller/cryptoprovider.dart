
import 'package:crypto_currency/src/domain/entity/crypto_currency_rate.dart';
import 'package:crypto_currency/src/ui/controller/sharedpreference.dart';
import 'package:crypto_currency/src/ui/models/alarm_info.dart';
import 'package:flutter/cupertino.dart';

class CryptoProvider extends ChangeNotifier {
 bool isFavPage =false;
 List<CryptoCurrencyRate> favList = [];
 List<String> favListName = [];
 List<AlarmInfo> searchAlarmList = [];
 List<CryptoCurrencyRate> searchCryptoList = [];
 List<CryptoCurrencyRate> cryptoList = [];
 List<CryptoCurrencyRate> allCryptoList = [];
 CryptoCurrencyRate cryptoCurrency;

 void setCryptoList( List<CryptoCurrencyRate>  cryptoCurrencyList){
   cryptoList ??= [];
   cryptoList = cryptoCurrencyList;
 }

 void addCryptoList(CryptoCurrencyRate cryptoCurrency){
   cryptoList ??= [];
   cryptoList.add(cryptoCurrency);
 }
 void setAllCryptoList(List<CryptoCurrencyRate>  cryptoCurrencyList){
   allCryptoList ??= [];
   allCryptoList = cryptoCurrencyList;
 }

 void addAllCryptoList(CryptoCurrencyRate cryptoCurrency){
   allCryptoList ??= [];
   allCryptoList.add(cryptoCurrency);
 }
 List<CryptoCurrencyRate> getAllCryptoList(){
   allCryptoList ??= [];
   return allCryptoList;
 }

 void setCryptoInfo(CryptoCurrencyRate cryptoCurrency,bool isFav){

   final CryptoCurrencyRate crypto = getCryptoCurrency(cryptoCurrency);

   if(crypto!=null){
     cryptoCurrency.isFav = isFav;
     this.cryptoCurrency = cryptoCurrency;
   }
 }

 CryptoCurrencyRate getCryptoCurrency(CryptoCurrencyRate cryptoCurrency){
   CryptoCurrencyRate crypto = cryptoList.singleWhere((it) => it.id == cryptoCurrency.id,
       orElse: () => null);
   return crypto;
 }

 bool getCryptoFavInfo(CryptoCurrencyRate cryptoCurrency){
   CryptoCurrencyRate crypto = getCryptoCurrency(cryptoCurrency);
   if(crypto!=null){
     if(crypto.isFav==null){
       return false;
     }
     if(crypto.isFav==null)
       return false;
     return crypto.isFav;
   }
   return false;
 }
 void setIsFavPage(bool isFav){
   isFavPage = isFav;
 }

 bool getFavPage(){
   return isFavPage;
 }

 void addFavList(CryptoCurrencyRate cryptoCurrencyRate,bool isFav){
   favList ??= [];
   if(isFav){
     setCryptoInfo(cryptoCurrencyRate,isFav);
     favList.add(cryptoCurrencyRate);
     favListName.add(cryptoCurrencyRate.name);
   }else{
     setCryptoInfo(cryptoCurrencyRate,isFav);
     favList.remove(cryptoCurrencyRate);
     favListName.remove(cryptoCurrencyRate.name);
   }
 }

 List<CryptoCurrencyRate> getFavList(){
   if(favListName!=null && favListName.isNotEmpty){
     for (var name in favListName) {
        setFavouriteList(name);
      }

   }
   return favList;
 }
 void setFavList(List<String> favNames){
   favListName ??= [];
   favListName = favNames;
   for (var name in favNames) {
     getCryptoCurrencyID(name);
    }

 }


 CryptoCurrencyRate getCryptoCurrencyID(String cryptoCurrencyName){
   CryptoCurrencyRate crypto;
   if(allCryptoList!=null && allCryptoList.isNotEmpty){
     crypto = allCryptoList.singleWhere((it) => it.name == cryptoCurrencyName, orElse: () => null);
     if(crypto!=null){
      if(!favList.contains(crypto)){
        addFavList(crypto, true);
      }
     }
   }
   return crypto;
 }

 void setFavouriteList(String cryptoCurrencyName){
   CryptoCurrencyRate crypto;
   CryptoCurrencyRate favcrypto;
   if(allCryptoList!=null && allCryptoList.isNotEmpty){
     crypto = allCryptoList.singleWhere((it) => it.name == cryptoCurrencyName, orElse: () => null);
     if(crypto!=null){
       if(favList!=null && favList.isNotEmpty){
         favcrypto = favList.singleWhere((it) => it.name == cryptoCurrencyName, orElse: () => null);
         if (favcrypto!=null) {
           favList.remove(favcrypto);
           if(favcrypto.isFav!=null) {
             favcrypto.isFav = true;
           }
           favList.add(favcrypto);
         }else{
           if(crypto.isFav!=null) {
             crypto.isFav = true;
           }
           favList.add(crypto);
         }
       }

     }
   }
 }

 void setSearchAlarmList(List<AlarmInfo> searchAlarmList) {
   this.searchAlarmList = searchAlarmList;
 }
 List<AlarmInfo> getSearchAlarmList() {
   return searchAlarmList;
 }
 void setSearchCryptoList(List<CryptoCurrencyRate> searchCryptoList) {
   this.searchCryptoList = searchCryptoList;
 }
 List<CryptoCurrencyRate> getSearchCryptoList() {
   return searchCryptoList;
 }
}
