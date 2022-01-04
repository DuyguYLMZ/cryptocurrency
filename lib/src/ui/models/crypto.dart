
class Crypto {
  var id;
  var name;
  var price;
  var symbol;

  Crypto({ this.id, this.name,  this.price, this.symbol});

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return new Crypto(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      price: json["quote"]["USD"]["price"],
    );
  }

  factory Crypto.fromMap(Map<String, dynamic> json) => Crypto(
    id: json['id'],
    name: json['name'],
    symbol: json['symbol'],
    price: json["price"]
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "symbol": symbol,
    "price": price
  };
}


/* _getMainBody() {
    if (_loading) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return new RefreshIndicator(
        child: _buildCryptoList(),
     //   onRefresh: getCryptoPrices,
      );
    }
  }*/
/* Widget _buildCryptoList() {
    return ListView.builder(
        itemCount: _cryptoList.length,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          final index = i;
          final MaterialColor color = _colors[index % _colors.length];
          return _buildRow(_cryptoList[index], color);
        });
  }*/

/* Widget _buildRow(Map crypto, MaterialColor color) {
    final bool favourited = _saved.contains(crypto);

    void _fav() {
      setState(() {
        if (favourited) {
          _saved.remove(crypto);
        } else {
          _saved.add(crypto);
        }
      });
    }

    return ListTile(
      leading: _getLeadingWidget(crypto['name'], color),
      title: Text(crypto['name'], style: TextStyle(
          fontFamily: 'avenir',
          fontWeight: FontWeight.w700,
          color: CustomColors.primaryTextColor,
          fontSize: 12)),
     /* subtitle: Text(
        style: _boldStyle,
      ),*/
      trailing: new IconButton(
        icon: Icon(favourited ? Icons.favorite : Icons.favorite_border),
        color: favourited ? Colors.red : null,
        onPressed: _fav,
      ),
    );
  }


  class SecondScreen extends StatefulWidget {
  final String payload;

  SecondScreen(this.payload);

  @override
  State<StatefulWidget> createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  String _payload;

  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  var newsList = {
    1: "Anand Mahindra gets note from 11 year girl to curb noise pollution",
    2: "26 yr old engineer brings 10 pons back to life",
    5: "Donald trump says windmill cause cancer."
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen with payload"),
      ),
      body: Center(
        child: Center(
          child: Text(
            newsList[int.parse(_payload)],
            // textDirection: TextDirection.LTR,
            style: TextStyle(
              fontSize: 17,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }


}

 */
