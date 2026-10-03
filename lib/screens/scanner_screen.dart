import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../services/product_service.dart';
import 'product_detail_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({
    super.key,
    required this.productService,
    required this.isActive,
  });

  final ProductService productService;
  final bool isActive;

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  late final MobileScannerController _controller;

  bool _processing = false;
  bool _starting = false;

  String _statusMessage = 'Point the camera at a product barcode or QR code.';

  String? _lastBarcode;
  DateTime? _lastBarcodeTime;

  @override
  void initState() {
    super.initState();

    _controller = MobileScannerController(
      autoStart: false,
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.normal,
      detectionTimeoutMs: 700,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.isActive) {
        _startScanner();
      }
    });
  }

  @override
  void didUpdateWidget(covariant ScannerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isActive == widget.isActive) {
      return;
    }

    if (widget.isActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _startScanner();
        }
      });
    } else {
      _stopScanner();
    }
  }

  Future<void> _startScanner() async {
    if (!mounted ||
        !widget.isActive ||
        _starting ||
        _controller.value.isRunning ||
        _controller.value.isStarting) {
      return;
    }

    _starting = true;

    try {
      await _controller.start();

      if (!mounted) {
        return;
      }

      setState(() {
        _statusMessage = 'Point the camera at a product barcode or QR code.';
      });
    } on MobileScannerException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _statusMessage = _scannerErrorMessage(error);
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _statusMessage = 'Unable to start camera: $error';
      });
    } finally {
      _starting = false;
    }
  }

  Future<void> _stopScanner() async {
    try {
      if (_controller.value.isRunning || _controller.value.isStarting) {
        await _controller.stop();
      }
    } catch (_) {
      // Scanner may already be stopped or uninitialised.
    }
  }

  Future<void> _handleDetection(BarcodeCapture capture) async {
    if (_processing || !widget.isActive) {
      return;
    }

    String? scannedValue;

    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue?.trim();

      if (value != null && value.isNotEmpty) {
        scannedValue = value;
        break;
      }
    }

    if (scannedValue == null) {
      return;
    }

    final now = DateTime.now();

    if (_lastBarcode == scannedValue &&
        _lastBarcodeTime != null &&
        now.difference(_lastBarcodeTime!) < const Duration(seconds: 3)) {
      return;
    }

    _lastBarcode = scannedValue;
    _lastBarcodeTime = now;

    setState(() {
      _processing = true;
      _statusMessage = 'Looking up barcode $scannedValue...';
    });

    await _stopScanner();

    try {
      final product = await widget.productService.findByBarcode(scannedValue);

      if (!mounted) {
        return;
      }

      if (product == null) {
        setState(() {
          _statusMessage = 'No inventory product was found for this barcode.';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No product found for barcode $scannedValue.'),
          ),
        );

        await Future<void>.delayed(const Duration(milliseconds: 900));

        return;
      }

      setState(() {
        _statusMessage = 'Product found: ${product.name}';
      });

      final result = await Navigator.of(context).push<String>(
        MaterialPageRoute<String>(
          builder: (_) => ProductDetailScreen(
            product: product,
            productService: widget.productService,
          ),
        ),
      );

      if (!mounted) {
        return;
      }

      if (result == 'updated') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated successfully.')),
        );
      } else if (result == 'deleted') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted successfully.')),
        );
      }

      setState(() {
        _statusMessage = 'Ready to scan another product barcode.';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _statusMessage = 'Product lookup failed.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not search inventory: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _processing = false;
        });

        if (widget.isActive) {
          await _startScanner();
        }
      }
    }
  }

  String _scannerErrorMessage(MobileScannerException error) {
    if (error.errorCode == MobileScannerErrorCode.permissionDenied) {
      return 'Camera permission was denied. Allow camera access and try again.';
    }

    if (error.errorCode == MobileScannerErrorCode.unsupported) {
      return 'Barcode scanning is not supported on this device.';
    }

    return 'The camera could not be started. Please try again.';
  }

  Widget _buildScannerError(
    BuildContext context,
    MobileScannerException error,
  ) {
    return Container(
      color: const Color(0xFF142129),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 58),
          const SizedBox(height: 18),
          Text(
            _scannerErrorMessage(error),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _startScanner,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try again'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scanner',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              'Scan a product barcode or QR code to find its inventory record.',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    MobileScanner(
                      controller: _controller,
                      onDetect: _handleDetection,
                      errorBuilder: _buildScannerError,
                      placeholderBuilder: (_) {
                        return Container(
                          color: const Color(0xFF142129),
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        );
                      },
                    ),
                    IgnorePointer(
                      child: Center(
                        child: Container(
                          width: 250,
                          height: 170,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 3),
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 18,
                      right: 18,
                      bottom: 18,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.68),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          _statusMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    if (_processing)
                      Container(
                        color: Colors.black.withValues(alpha: 0.55),
                        alignment: Alignment.center,
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(color: Colors.white),
                            SizedBox(height: 16),
                            Text(
                              'Searching inventory...',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
