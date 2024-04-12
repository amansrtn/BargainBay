import 'package:bhashini/Seller/Classes/text_class.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextClass textclass = TextClass();
  ColorClass colorclass = ColorClass();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: textclass.subTitle,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Details Card
              Text(
                "Aman Kumar Singh",
                style: TextStyle(
                    fontSize: 32,
                    color: colorclass.grey,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins"),
              ),
              const SizedBox(
                height: 8,
              ),
              Text("8638332396", style: textclass.heading1),
              const SizedBox(
                height: 8,
              ),
              Text("F-16, Beta 2, Greater Noida, UP, India",
                  style: textclass.heading1),
              const SizedBox(
                height: 24,
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              // Monthly Sales Chart
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: colorclass.palewhite,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly Sales',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      height: 200,
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: <ChartSeries>[
                          LineSeries<SalesData, String>(
                            dataSource: _createMonthlySalesData(),
                            xValueMapper: (SalesData sales, _) => sales.month,
                            yValueMapper: (SalesData sales, _) => sales.amount,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              // Daily Sales Chart
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: colorclass.palewhite,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Sales',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      height: 200,
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: <ChartSeries>[
                          BarSeries<SalesData, String>(
                            dataSource: _createDailySalesData(),
                            xValueMapper: (SalesData sales, _) => sales.day,
                            yValueMapper: (SalesData sales, _) => sales.amount,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to create sample monthly sales data
  List<SalesData> _createMonthlySalesData() {
    return [
      SalesData('Jan', 100),
      SalesData('Feb', 200),
      SalesData('Mar', 150),
      SalesData('Apr', 300),
      // Add more data points for each month
    ];
  }

  // Function to create sample daily sales data
  List<SalesData> _createDailySalesData() {
    return [
      SalesData('Mon', 50),
      SalesData('Tue', 100),
      SalesData('Wed', 150),
      SalesData('Thu', 200),
      // Add more data points for each day
    ];
  }
}

// Model class for sales data
class SalesData {
  final String month; // for monthly sales
  final String day; // for daily sales
  final int amount;

  SalesData(this.month, this.amount) : day = '';

  SalesData.withDay(this.day, this.amount) : month = '';
}
