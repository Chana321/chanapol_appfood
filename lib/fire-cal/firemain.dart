import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'calc.dart';

class Shopping extends StatefulWidget {
  const Shopping({super.key});

  @override
  State<Shopping> createState() => _ShoppingState();
}

class _ShoppingState extends State<Shopping> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  int khaopad = 0;
  int kaprao = 0;
  int somtam = 0;
  int kuayteaw = 0;
  int khaomangai = 0;
  int padthai = 0;
  int khaokhamoo = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 148, 9),
        elevation: 4,
        centerTitle: true,
        leading: const Icon(
          Icons.restaurant_menu,
          size: 28,
          color: Colors.white,
        ),
        title: const Text(
          "Food Order",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),

      /// ✅ แก้ตรงนี้
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "เลือกอาหารที่ต้องการสั่ง",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              _buildFoodItem(
                "ต้มยำกุ้งน้ำข้น",
                40,
                "assets/tom.png",
                khaopad,
                (val) => setState(() => khaopad = val),
              ),

              _buildFoodItem(
                "ไก่ทอด(กรอบ)",
                45,
                "assets/kai1.png",
                kaprao,
                (val) => setState(() => kaprao = val),
              ),

              _buildFoodItem(
                "ผัดเผ็ดปลาดุก",
                35,
                "assets/ped.png",
                somtam,
                (val) => setState(() => somtam = val),
              ),

              _buildFoodItem(
                "ข้าวหน้าหมู(ราดซอส)",
                40,
                "assets/kaomoo.png",
                kuayteaw,
                (val) => setState(() => kuayteaw = val),
              ),

              _buildFoodItem(
                "พุดดิ้งเต้าหู้",
                50,
                "assets/tao.png",
                khaomangai,
                (val) => setState(() => khaomangai = val),
              ),

              _buildFoodItem(
                "บานอฟฟี่(Banana)",
                45,
                "assets/ba.png",
                padthai,
                (val) => setState(() => padthai = val),
              ),

              _buildFoodItem(
                "MangoCake",
                50,
                "assets/mk.png",
                khaokhamoo,
                (val) => setState(() => khaokhamoo = val),
              ),

              const SizedBox(height: 30),

              /// ปุ่มล่าง
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        khaopad = 0;
                        kaprao = 0;
                        somtam = 0;
                        kuayteaw = 0;
                        khaomangai = 0;
                        padthai = 0;
                        khaokhamoo = 0;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("ล้างข้อมูล"),
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      int total =
                          khaopad +
                          kaprao +
                          somtam +
                          kuayteaw +
                          khaomangai +
                          padthai +
                          khaokhamoo;

                      if (total == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("กรุณาเลือกอาหารอย่างน้อย 1 รายการ"),
                          ),
                        );
                        return;
                      }

                      List<Map<String, dynamic>> items = [];
                      int netTotal = 0;

                      void addItem(String name, int price, int pc) {
                        if (pc > 0) {
                          int t = price * pc;
                          items.add({
                            "item": name,
                            "price": price,
                            "pc": pc,
                            "total": t,
                          });
                          netTotal += t;
                        }
                      }

                      addItem("ต้มยำกุ้ง", 40, khaopad);
                      addItem("ไก่ทอด", 45, kaprao);
                      addItem("ผัดเผ็ดปลาดุก", 35, somtam);
                      addItem("ข้าวหมู", 40, kuayteaw);
                      addItem("พุดดิ้ง", 50, khaomangai);
                      addItem("บานอฟฟี่", 45, padthai);
                      addItem("MangoCake", 50, khaokhamoo);

                      await firestore.collection("food_tab").add({
                        "items": items,
                        "net_total": netTotal,
                        "timestamp": FieldValue.serverTimestamp(),
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CalcPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("คำนวณราคา"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoodItem(
    String name,
    int price,
    String imagePath,
    int quantity,
    Function(int) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 60,
                height: 60,
                color: Colors.grey[300],
                child: const Icon(Icons.restaurant),
              ),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "ราคา $price บาท",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              if (quantity > 0) onChanged(quantity - 1);
            },
            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "$quantity",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          IconButton(
            onPressed: () => onChanged(quantity + 1),
            icon: const Icon(Icons.add_circle_outline, color: Colors.green),
          ),
        ],
      ),
    );
  }
}
