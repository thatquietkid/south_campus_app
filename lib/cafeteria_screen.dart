import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CafeteriaScreen extends StatefulWidget {
  const CafeteriaScreen({super.key});

  @override
  State<CafeteriaScreen> createState() => _CafeteriaScreenState();
}

class _CafeteriaScreenState extends State<CafeteriaScreen> {
  final Map<String, String?> _centralCafeteria = {
    'name': 'Central Cafeteria',
    'location': 'Near the Faculty of Arts',
    'hours': 'Monday - Friday: 8:00 AM - 8:00 PM, Saturday: 9:00 AM - 6:00 PM',
    'contact': '011-2766XXXX',
  };

  List<Map<String, dynamic>> _fullMenu = [];
  List<Map<String, dynamic>> _filteredMenu = [];
  final TextEditingController _searchController = TextEditingController();
  final Map<String, int> _selectedItems = {}; // Item name -> quantity
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchMenu();
    _searchController.addListener(_filterMenu);
  }

  Future<void> _fetchMenu() async {
    try {
      final response = await http.get(Uri.parse('https://south-campus-backend.onrender.com/cafeteria-items'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _fullMenu = data.map((item) => {
            'item': item['item_name'],
            'price': item['price'].toString(),
          }).toList();
          _filteredMenu = List.from(_fullMenu);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load menu');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterMenu() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMenu = _fullMenu.where((item) {
        return item['item']?.toLowerCase().contains(query) ?? false;
      }).toList();
    });
  }

  void _toggleItem(String itemName) {
    setState(() {
      if (_selectedItems.containsKey(itemName)) {
        _selectedItems.remove(itemName);
      } else {
        _selectedItems[itemName] = 1;
      }
    });
  }

  void _updateQuantity(String itemName, int change) {
    setState(() {
      if (_selectedItems.containsKey(itemName)) {
        final newQuantity = (_selectedItems[itemName]! + change).clamp(0, 10);
        if (newQuantity > 0) {
          _selectedItems[itemName] = newQuantity;
        } else {
          _selectedItems.remove(itemName);
        }
      }
    });
  }

  double get _totalPrice {
    double total = 0;
    _selectedItems.forEach((itemName, quantity) {
      final item = _fullMenu.firstWhere((element) => element['item'] == itemName, orElse: () => {'price': '0'});
      total += double.parse(item['price'] ?? '0') * quantity;
    });
    return total;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Central Cafeteria'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(child: Text('Error: $_error'))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _centralCafeteria['name'] ?? 'Cafeteria Unavailable',
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            _buildDetailRow('Location', _centralCafeteria['location']),
            _buildDetailRow('Operating Hours', _centralCafeteria['hours']),
            _buildDetailRow('Contact', _centralCafeteria['contact']),
            const SizedBox(height: 16.0),
            const Text(
              'Menu:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search menu items...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.separated(
                itemCount: _filteredMenu.length,
                separatorBuilder: (context, index) => const Divider(height: 1.0),
                itemBuilder: (context, index) {
                  final menuItem = _filteredMenu[index];
                  final itemName = menuItem['item']!;
                  final quantity = _selectedItems[itemName] ?? 0;
                  final isSelected = _selectedItems.containsKey(itemName);
                  return InkWell(
                    onTap: () => _toggleItem(itemName),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isSelected ? Icons.check_circle : Icons.circle_outlined,
                                color: isSelected ? Colors.green : Colors.grey,
                                size: 20.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  itemName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    decoration: isSelected ? TextDecoration.underline : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('₹${menuItem['price']}',
                                  style: const TextStyle(fontWeight: FontWeight.w500)),
                              if (isSelected)
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () => _updateQuantity(itemName, -1),
                                      iconSize: 20.0,
                                    ),
                                    Text('$quantity'),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () => _updateQuantity(itemName, 1),
                                      iconSize: 20.0,
                                    ),
                                  ],
                                ),
                              if (!isSelected)
                                const SizedBox(width: 100.0), // Adjust width as needed
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total:',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                  Text('₹${_totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.blue)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value ?? 'Not Available')),
        ],
      ),
    );
  }
}
