import 'package:flutter/material.dart';

class BusinessSelection extends StatefulWidget{
  const BusinessSelection({super.key})
  
  @override
  State<BusinessSelection> createState() => _BusinessSelection();
}

class _BusinessSelection extends State<BusinessSelection> {

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Placeholder',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
            ),
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Placeholder',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
      ],
    );
  }
}