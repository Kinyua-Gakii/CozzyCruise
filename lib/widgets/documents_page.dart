import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const Color appYellow = Color(0xFFF6C945);
const Color appBlack = Color(0xFF111111);

enum DocStatus { notSubmitted, pending, verified }

class _DocumentEntry {
  final String label;
  DocStatus status;
  Uint8List? bytes;
  String? fileName;

  _DocumentEntry({
    required this.label,
    required this.status,
    this.bytes,
    this.fileName,
  });
}

class DocumentsPage extends StatefulWidget {
  final Map<String, dynamic>? documents;

  const DocumentsPage({super.key, this.documents});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  final ImagePicker _picker = ImagePicker();
  bool submitting = false;

  static const Map<String, String> _fields = {
    'license': 'Driving License',
    'id': 'National ID',
    'registration': 'Vehicle Registration',
    'insurance': 'Insurance Certificate',
    'tax_clearance': 'Tax Clearance',
  };

  late final Map<String, _DocumentEntry> entries;

  @override
  void initState() {
    super.initState();
    entries = {
      for (final field in _fields.entries)
        field.key: _DocumentEntry(
          label: field.value,
          status: _statusFromRaw(widget.documents?[field.key]),
        ),
    };
  }

  DocStatus _statusFromRaw(dynamic raw) {
    final value = (raw ?? '').toString().toLowerCase();
    if (value == 'verified') return DocStatus.verified;
    if (value.isEmpty || value == 'not submitted') {
      return DocStatus.notSubmitted;
    }
    return DocStatus.pending;
  }

  Future<void> _handleTap(String key) async {
    final entry = entries[key]!;

    if (entry.status == DocStatus.verified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("This document is already verified")),
      );
      return;
    }

    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    // Read bytes rather than relying on dart:io File access, so this
    // works the same on web and native.
    final bytes = await picked.readAsBytes();

    setState(() {
      entry.bytes = bytes;
      entry.fileName = picked.name;
      entry.status = DocStatus.pending;
    });
  }

  Future<void> _handleSubmit() async {
    final stillMissing = entries.values.any(
      (e) => e.status == DocStatus.notSubmitted,
    );
    if (stillMissing) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload all required documents")),
      );
      return;
    }

    setState(() => submitting = true);

    // TODO: replace this simulated delay with a real upload once the
    // backend is ready. For each entry with status == pending, send
    // entry.bytes (and entry.fileName) via multipart/form-data, e.g.
    // http.MultipartFile.fromBytes(key, entry.bytes!, filename: entry.fileName).
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => submitting = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Documents submitted")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
        backgroundColor: Colors.white,
        foregroundColor: appBlack,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF9F7F3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final key in _fields.keys) documentCard(key, entries[key]!),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appYellow,
                    foregroundColor: appBlack,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: submitting ? null : _handleSubmit,
                  child: submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: appBlack,
                          ),
                        )
                      : const Text(
                          'Submit Documents',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget documentCard(String key, _DocumentEntry entry) {
    final isVerified = entry.status == DocStatus.verified;
    final isPending = entry.status == DocStatus.pending;

    final color = isVerified
        ? Colors.green
        : isPending
        ? Colors.orange
        : Colors.grey;
    final icon = isVerified
        ? Icons.check_circle
        : isPending
        ? Icons.pending
        : Icons.upload_file_outlined;
    final statusText = isVerified
        ? 'Verified'
        : isPending
        ? (entry.fileName != null
              ? 'Pending review · ${entry.fileName}'
              : 'Pending review')
        : 'Not submitted';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _handleTap(key),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.98),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: appBlack,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isVerified)
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.withValues(alpha: 0.5),
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
