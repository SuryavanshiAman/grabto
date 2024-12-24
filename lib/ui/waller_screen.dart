import 'package:flutter/material.dart';

import '../theme/theme.dart';

class WallerScreen extends StatelessWidget {

  List<Map<String, dynamic>> walletHistoryList = [
    {
      'images':
      'https://pricemenu.in/wp-content/uploads/2023/10/Subway-Menu-And-Prices.jpg',
      'title': 'Add Money',
      'time': '20:00',
      'day': '5 Day',
      'postiveornagtive': '+',
      'money': '100'
    },
    {
      'images':
      'https://pricemenu.in/wp-content/uploads/2023/10/Subway-Menu-And-Prices.jpg',
      'title': 'Add Money',
      'time': '20:00',
      'day': '5 Day',
      'postiveornagtive': '+',
      'money': '100'
    },
    {
      'images':
      'https://pricemenu.in/wp-content/uploads/2023/10/Subway-Menu-And-Prices.jpg',
      'title': 'Add Money',
      'time': '20:00',
      'day': '5 Day',
      'postiveornagtive': '+',
      'money': '100'
    },{
      'images':
      'https://pricemenu.in/wp-content/uploads/2023/10/Subway-Menu-And-Prices.jpg',
      'title': 'Add Money',
      'time': '20:00',
      'day': '5 Day',
      'postiveornagtive': '+',
      'money': '100'
    },
    {
      'images':
      'https://pricemenu.in/wp-content/uploads/2023/10/Subway-Menu-And-Prices.jpg',
      'title': 'Add Money',
      'time': '20:00',
      'day': '5 Day',
      'postiveornagtive': '+',
      'money': '100'
    },


    // Add more items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundBg,
      appBar: AppBar(
        backgroundColor: MyColors.backgroundBg,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: Text(
          "Wallet",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: MyColors.backgroundBg,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(5),
                child: Stack(
                  children: [
                    Container(
                      // margin: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Card(
                            color: Color(0xFFF8EDB9),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              height: 180,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Center(
                                    child: Container(
                                      width: 230,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Referral Point Balance",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: MyColors.txtTitleColor),
                                          ),
                                          Center(
                                              child: Text(
                                            "0",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w400,
                                                color: MyColors.primaryColor
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // decoration: BoxDecoration(
                              //   image: DecorationImage(
                              //     image: NetworkImage(
                              //         "https://img.freepik.com/free-vector/special-offer-modern-sale-banner-template_1017-20667.jpg?size=626&ext=jpg&ga=GA1.1.2082370165.1706140800&semt=ais"),
                              //     fit: BoxFit.fill,
                              //   ),
                              // ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Positioned(
                        top: 0,
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: Container(
                            height: 60,
                            width: 60,
                            color: MyColors.primaryColor,
                            child: Icon(Icons.wallet,color: Colors.white,),

                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),

              Container(
                margin:
                EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Transaction History",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                  ],
                ),
              ),
              historywallet(walletHistoryList),


              SizedBox(
                height: 50,
              )

            ],
          ),
        ),
      ),
    );
  }
}

class historywallet extends StatelessWidget{

  List<Map<String, dynamic>> walletHistoryList;

  historywallet(this.walletHistoryList);




  @override
  Widget build(BuildContext context) {

    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: walletHistoryList.length, // Replace with your actual number of cards
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return buildTransactionWidget(
            context,
              "" + walletHistoryList[index]['images'],
              "" + walletHistoryList[index]['title'],
              "" + walletHistoryList[index]['time'],
              "" + walletHistoryList[index]['day'],
              "" + walletHistoryList[index]['postiveornagtive'],
              "" + walletHistoryList[index]['money'],
          );
        },
      ),
    );
  }

  Widget buildTransactionWidget(BuildContext context, String images,
      String title, String time, String day,String postiveornagtive,String money) {
    var we = MediaQuery.of(context).size.width;
    var he  = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      child: Container(
        width: we * 0.9,
        height: he * 0.085,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.0),
            color: const Color(0xFFFFFFFF)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(children: [
              CircleAvatar(
                backgroundImage: NetworkImage(images),//""
              ),
              SizedBox(
                width: we * 0.04,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,style: const TextStyle(color:Colors.black)),
                  // SizedBox(
                  //   height: he * 0.01,
                  // ),
                  Row(
                    children:  [
                      Text(time,style: const TextStyle(color:Colors.grey)),
                      SizedBox(width:  we * 0.04,),
                      Text(day,style: const TextStyle(color:Colors.grey)),
                    ],)
                ],
              ),
            ],),

            SizedBox(
              width:we * 0.16,
            ),
            Row(
              children: [
                Text(postiveornagtive,style: const TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold)),
                // Image.asset("assets/images/logo.png",
                //   width: we * 0.035,
                //   height: we * 0.035,
                //   //color: Colors.black,
                // ),
                Text(money,style:const TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.bold),)
              ],
            ),

          ],
        ),
      ),
    );;
  }

}


