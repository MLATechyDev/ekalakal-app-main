import 'package:ekalakal/information/edit_profile.dart';
import 'package:flutter/material.dart';

class EditAddress extends StatefulWidget {
  const EditAddress({super.key});

  @override
  State<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  final items = [
    'Bagong Nayon',
    'Barangca',
    'Calantipay',
    'Catulinan',
    'Concepcion',
    'Hinukay',
    'Makinabang',
    'Matang Tubig',
    'Pagala',
    'Paitan',
    'Piel',
    'Pinagbarilan',
    'Poblacion',
    'Sabang',
    'San Jose',
    'San Roque',
    'Santa Barbara',
    'Santo Cristo',
    'Santo Niño',
    'Subic',
    'Sulivan',
    'Tangos',
    'Tarcan',
    'Tiaong',
    'Tibag',
    'Tilapayong',
    'Virgen delos Flores'
  ];
  final streetNameTEC = TextEditingController();
  final cityProvince = TextEditingController();
  String? value;
  late String address;
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    cityProvince.text = 'Baliuag, Bulacan';
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text('Edit Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 8, right: 8, bottom: 8),
        child: Form(
          key: formkey,
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (streetNameTEC.text.isEmpty || value == null) {
                    return " Please fill this field!";
                  } else {
                    return null;
                  }
                },
                controller: streetNameTEC,
                decoration: InputDecoration(
                  labelText: 'Street Name, Building, House No.',
                  contentPadding: EdgeInsets.only(
                    right: 10,
                    left: 10,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(10)),
                height: 40,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      hint: Text('Select Barangay'),
                      value: value,
                      menuMaxHeight: 400,
                      onChanged: (value) {
                        setState(() {
                          this.value = value;
                        });
                      },
                      items: items.map(buildMenuItems).toList()),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) {
                  if (cityProvince.text.isEmpty || value == null) {
                    return " Please fill this field!";
                  } else if (value.length < 10) {
                    return "Please enter a valid Address";
                  } else {
                    return null;
                  }
                },
                controller: cityProvince,
                decoration: InputDecoration(
                  labelText: 'City, Province',
                  contentPadding: EdgeInsets.only(
                    right: 10,
                    left: 10,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  address =
                      '${streetNameTEC.text} ${value.toString()} ${cityProvince.text}';
                  final isValid = formkey.currentState!.validate();
                  if (!isValid) return;
                  Navigator.of(context).pop(address);
                },
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                    minimumSize: Size(MediaQuery.of(context).size.width, 40)),
              )
            ],
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItems(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ));
}
