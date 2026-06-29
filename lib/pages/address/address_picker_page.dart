// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/controllers/location_controller.dart';
import 'package:food_delivery_app/utils/colors.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressPickerPage extends StatefulWidget {
  const AddressPickerPage({super.key});

  @override
  State<AddressPickerPage> createState() => _AddressPickerPageState();
}

class _AddressPickerPageState extends State<AddressPickerPage>
    with SingleTickerProviderStateMixin {
  // Map
  final Completer<GoogleMapController> _mapCtrlCompleter = Completer();
  late CameraPosition _cameraPosition;
  static const LatLng _nairobiCenter = LatLng(-1.2846464, 36.8199579);

  // Pin drop animation
  late AnimationController _pinCtrl;
  late Animation<double> _pinAnim;

  // Search / suggestions
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  bool _showSuggestions = false;
  String _filter = '';

  static const _suggestions = [
    {'label': 'Karen, Nairobi', 'lat': -1.3135, 'lng': 36.7115},
    {'label': 'Westlands, Nairobi', 'lat': -1.2636, 'lng': 36.8063},
    {'label': 'Upper Hill, Nairobi', 'lat': -1.2993, 'lng': 36.8138},
    {'label': 'Kilimani, Nairobi', 'lat': -1.2879, 'lng': 36.7852},
    {'label': 'Lavington, Nairobi', 'lat': -1.2756, 'lng': 36.7737},
    {'label': 'South B, Nairobi', 'lat': -1.3098, 'lng': 36.8349},
    {'label': 'Eastleigh, Nairobi', 'lat': -1.2736, 'lng': 36.8548},
    {'label': 'Ngong Road, Nairobi', 'lat': -1.3064, 'lng': 36.7780},
    {'label': 'Kileleshwa, Nairobi', 'lat': -1.2771, 'lng': 36.7830},
    {'label': 'Muthaiga, Nairobi', 'lat': -1.2468, 'lng': 36.8325},
  ];

  // Address label selection
  int _selectedLabel = 0;
  static const _labels = [
    {'emoji': '🏠', 'name': 'Home'},
    {'emoji': '🏢', 'name': 'Work'},
    {'emoji': '❤️', 'name': 'Partner'},
    {'emoji': '📍', 'name': 'Other'},
  ];

  final TextEditingController _floorCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();

  // "Use my location" state
  bool _locating = false;
  String _detectedAddress = '';

  @override
  void initState() {
    super.initState();
    _cameraPosition = CameraPosition(target: _nairobiCenter, zoom: 14);

    _pinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _pinAnim = Tween<double>(begin: -30, end: 0).animate(
      CurvedAnimation(parent: _pinCtrl, curve: Curves.bounceOut),
    );
    _pinCtrl.forward();

    _searchFocus.addListener(() {
      if (!_searchFocus.hasFocus && mounted) {
        setState(() => _showSuggestions = false);
      }
    });
  }

  @override
  void dispose() {
    _pinCtrl.dispose();
    _searchCtrl.dispose();
    _searchFocus.dispose();
    _floorCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered {
    if (_filter.isEmpty) return List.from(_suggestions);
    return _suggestions
        .where((s) => (s['label'] as String).toLowerCase().contains(_filter.toLowerCase()))
        .toList();
  }

  Future<void> _flyTo(double lat, double lng) async {
    final ctrl = await _mapCtrlCompleter.future;
    final pos = CameraPosition(target: LatLng(lat, lng), zoom: 16);
    await ctrl.animateCamera(CameraUpdate.newCameraPosition(pos));
    _pinCtrl.reset();
    _pinCtrl.forward();
  }

  Future<void> _useMyLocation() async {
    setState(() => _locating = true);
    try {
      final mapCtrl = await _mapCtrlCompleter.future;
      final loc = Get.find<LocationController>();
      await loc.getCurrrentLocation(false, mapController: mapCtrl);
      final name = loc.pickPlacemark.name ?? 'Your location';
      setState(() {
        _detectedAddress = name;
        _locating = false;
      });
      final pos = loc.pickPosition;
      if (pos.latitude != 0) {
        await _flyTo(pos.latitude, pos.longitude);
      }
    } catch (_) {
      setState(() {
        _detectedAddress = 'Upper Hill Road, Nairobi';
        _locating = false;
      });
    }
  }

  void _onCameraMove(CameraPosition pos) {
    setState(() => _cameraPosition = pos);
  }

  void _onCameraIdle() {
    Get.find<LocationController>().updatePosition(_cameraPosition, false);
    final loc = Get.find<LocationController>();
    final name = loc.pickPlacemark.name;
    if (name != null && name.isNotEmpty) {
      setState(() => _detectedAddress = name);
    }
  }

  // ── Widgets ──────────────────────────────────────────────────────────────────

  Widget _buildMap() {
    return GoogleMap(
      initialCameraPosition: _cameraPosition,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      onCameraMove: _onCameraMove,
      onCameraIdle: _onCameraIdle,
      onTap: (_) => setState(() => _showSuggestions = false),
      onMapCreated: (c) {
        if (!_mapCtrlCompleter.isCompleted) _mapCtrlCompleter.complete(c);
        Get.find<LocationController>().setMapController(c);
      },
    );
  }

  Widget _buildCenterPin() {
    return Center(
      child: AnimatedBuilder(
        animation: _pinAnim,
        builder: (_, __) => Transform.translate(
          offset: Offset(0, _pinAnim.value - 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: AppColors.mainColor, shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 8, offset: Offset(0, 4))],
                ),
                child: Icon(Icons.location_on, color: Colors.white, size: 26),
              ),
              // Pin tail
              Container(width: 3, height: 12, color: AppColors.mainColor),
              // Shadow dot
              Container(
                width: 10, height: 4,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 10, offset: Offset(0, 3))],
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios, size: 18, color: Colors.black87),
                onPressed: () => Get.back(),
              ),
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  focusNode: _searchFocus,
                  decoration: InputDecoration(
                    hintText: 'Search for area, street name...',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                  ),
                  style: TextStyle(fontSize: 14),
                  onChanged: (v) => setState(() {
                    _filter = v;
                    _showSuggestions = v.isNotEmpty;
                  }),
                  onTap: () => setState(() => _showSuggestions = true),
                ),
              ),
              if (_searchCtrl.text.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.close, size: 18, color: Colors.grey.shade500),
                  onPressed: () {
                    _searchCtrl.clear();
                    setState(() { _filter = ''; _showSuggestions = false; });
                  },
                ),
            ],
          ),
        ),
        if (_showSuggestions && _filtered.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.10), blurRadius: 8, offset: Offset(0, 3))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _filtered.take(6).map((s) {
                  return InkWell(
                    onTap: () async {
                      _searchCtrl.text = s['label'] as String;
                      setState(() { _filter = ''; _showSuggestions = false; _detectedAddress = s['label'] as String; });
                      _searchFocus.unfocus();
                      await _flyTo(s['lat'] as double, s['lng'] as double);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: AppColors.mainColor, size: 18),
                          SizedBox(width: 12),
                          Expanded(child: Text(s['label'] as String, style: TextStyle(fontSize: 14, color: Colors.black87))),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );

    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 0,
      right: 0,
      child: isDesktop
          ? Center(child: SizedBox(width: 560, child: content))
          : Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: content),
    );
  }

  Widget _buildUseLocationBtn() {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    return Positioned(
      bottom: isDesktop ? 420 : 300,
      right: 16,
      child: GestureDetector(
        onTap: _locating ? null : _useMyLocation,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 8, offset: Offset(0, 2))],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _locating
                  ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: AppColors.mainColor, strokeWidth: 2))
                  : Icon(Icons.my_location, color: AppColors.mainColor, size: 18),
              SizedBox(width: 8),
              Text(_locating ? 'Locating...' : 'Use my location',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    final displayAddress = _detectedAddress.isNotEmpty
        ? _detectedAddress
        : (_searchCtrl.text.isNotEmpty ? _searchCtrl.text : 'Upper Hill Road, Nairobi');

    final isDesktop = MediaQuery.of(context).size.width > 900;
    final sheet = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 20, offset: Offset(0, -4))],
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
              ),
              SizedBox(height: 16),

              // Selected location
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: AppColors.mainColor, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SELECTED LOCATION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey.shade500, letterSpacing: 1)),
                          SizedBox(height: 3),
                          Text(displayAddress, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => _searchFocus.requestFocus(),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      child: Text('Change', style: TextStyle(color: AppColors.mainColor, fontSize: 13, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Save as label
              Text('Save as', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              SizedBox(height: 10),
              Row(
                children: _labels.asMap().entries.map((e) {
                  final selected = _selectedLabel == e.key;
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedLabel = e.key),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 180),
                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected ? Color(0xFFE6FAFA) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: selected ? AppColors.mainColor : Colors.grey.shade300, width: selected ? 1.5 : 1),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text(e.value['emoji']!, style: TextStyle(fontSize: 14)),
                          SizedBox(width: 5),
                          Text(e.value['name']!, style: TextStyle(fontSize: 13, fontWeight: selected ? FontWeight.w600 : FontWeight.normal, color: selected ? AppColors.mainColor : Colors.black87)),
                        ]),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),

              // Floor / Unit
              Text('FLOOR / UNIT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade500, letterSpacing: 1.2)),
              SizedBox(height: 8),
              TextField(
                controller: _floorCtrl,
                decoration: InputDecoration(
                  hintText: 'e.g. 3rd floor, Apt 12',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  prefixIcon: Icon(Icons.business_outlined, color: Colors.grey.shade400, size: 20),
                  filled: true, fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                ),
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 14),

              // Delivery note
              Text('DELIVERY NOTE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade500, letterSpacing: 1.2)),
              SizedBox(height: 8),
              TextField(
                controller: _noteCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'e.g. Blue gate, ring bell twice...',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  filled: true, fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                  contentPadding: EdgeInsets.all(12),
                ),
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 20),

              // Save button
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => Get.back(result: {
                    'address': displayAddress,
                    'icon': _labels[_selectedLabel]['emoji']!,
                    'name': _labels[_selectedLabel]['name']!,
                  }),
                  icon: Icon(Icons.check, size: 18, color: Colors.white),
                  label: Text('Save Address', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor, elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ],
          ),
        ),
    );

    return Positioned(
      left: 0, right: 0, bottom: 0,
      child: isDesktop
          ? Center(child: SizedBox(width: 640, child: sheet))
          : sheet,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildMap(),
          _buildCenterPin(),
          _buildSearchBar(),
          _buildUseLocationBtn(),
          _buildBottomSheet(),
        ],
      ),
    );
  }
}
