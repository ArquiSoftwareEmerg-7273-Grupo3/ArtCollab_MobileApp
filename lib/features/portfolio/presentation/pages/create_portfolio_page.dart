import 'package:flutter/material.dart';
import 'package:artcollab_mobile/features/portfolio/data/remote/portfolio_service.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';
import 'package:artcollab_mobile/core/theme/app_theme.dart';
import 'package:artcollab_mobile/shared/widgets/elegant_form_field.dart';
import 'package:artcollab_mobile/shared/widgets/elegant_button.dart';
import 'package:artcollab_mobile/shared/widgets/elegant_card.dart';
import 'package:image_picker/image_picker.dart';
import 'package:artcollab_mobile/features/feed/data/remote/media_service.dart';
import 'dart:io';

class CreatePortfolioPage extends StatefulWidget {
  const CreatePortfolioPage({super.key});

  @override
  State<CreatePortfolioPage> createState() => _CreatePortfolioPageState();
}

class _CreatePortfolioPageState extends State<CreatePortfolioPage> {
  final _formKey = GlobalKey<FormState>();
  final PortfolioService _portfolioService = PortfolioService();
  final ImagePicker _imagePicker = ImagePicker();
  
  // Controllers
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _tecnicasController = TextEditingController();
  final _softwareController = TextEditingController();
  
  // State
  bool _isLoading = false;
  String _categoria = 'ILUSTRACION';
  List<XFile> _selectedImages = [];
  
  final List<String> _categorias = [
    'ILUSTRACION',
    'DISENO_GRAFICO',
    'ANIMACION',
    'CONCEPT_ART',
    'STORYBOARD',
    'PINTURA_DIGITAL',
    'ARTE_TRADICIONAL',
  ];

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _tecnicasController.dispose();
    _softwareController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        imageQuality: 85,
      );
      
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images);
          // Limitar a 10 imágenes
          if (_selectedImages.length > 10) {
            _selectedImages = _selectedImages.sublist(0, 10);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar imágenes: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _createPortfolio() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes seleccionar al menos una imagen'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      // Primero subir la primera imagen al servidor
      String? uploadedImageUrl;
      if (_selectedImages.isNotEmpty) {
        final mediaService = MediaService();
        final file = File(_selectedImages[0].path);
        final uploadResult = await mediaService.uploadFile(file: file);
        
        if (uploadResult is Success<String>) {
          uploadedImageUrl = uploadResult.data;
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al subir imagen: ${(uploadResult as Error).message}'),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          }
          setState(() => _isLoading = false);
          return;
        }
      }
      
      final result = await _portfolioService.createPortfolio(
        titulo: _tituloController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        urlImagen: uploadedImageUrl,
        categoria: _categoria,
        tecnicas: _tecnicasController.text.trim(),
        software: _softwareController.text.trim(),
        imagePaths: _selectedImages.map((img) => img.path).toList(),
      );
      
      if (result is Success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: AppTheme.spacingSmall),
                Text('Portafolio creado exitosamente'),
              ],
            ),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
            ),
          ),
        );
        Navigator.pop(context, true);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: AppTheme.spacingSmall),
                Expanded(
                  child: Text(
                    result is Error ? (result.message ?? 'Error al crear portafolio') : 'Error al crear portafolio',
                  ),
                ),
              ],
            ),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error inesperado: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Crear Portafolio'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              ElegantCard(
                type: ElegantCardType.gradient,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingSmall),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                      ),
                      child: const Icon(
                        Icons.palette_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nueva Obra',
                            style: context.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingXSmall),
                          Text(
                            'Comparte tu trabajo con la comunidad',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppTheme.spacingLarge),
              
              // Imágenes
              Text(
                'Imágenes',
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.spacingSmall),
              Text(
                'Selecciona hasta 10 imágenes de tu obra',
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              
              // Grid de imágenes seleccionadas
              if (_selectedImages.isNotEmpty)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: AppTheme.spacingSmall,
                    mainAxisSpacing: AppTheme.spacingSmall,
                  ),
                  itemCount: _selectedImages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _selectedImages.length) {
                      return _buildAddImageButton();
                    }
                    return _buildImagePreview(index);
                  },
                )
              else
                _buildAddImageButton(),
              
              const SizedBox(height: AppTheme.spacingLarge),
              
              // Información básica
              Text(
                'Información de la Obra',
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              
              ElegantFormField(
                label: 'Título',
                hint: 'Ej: Retrato Digital Fantasy',
                prefixIcon: Icons.title,
                controller: _tituloController,
                validator: (value) => _validateRequired(value, 'El título'),
              ),
              
              const SizedBox(height: AppTheme.spacingMedium),
              
              ElegantFormField(
                label: 'Descripción',
                hint: 'Describe tu obra, el proceso creativo, inspiración...',
                prefixIcon: Icons.description,
                controller: _descripcionController,
                validator: (value) => _validateRequired(value, 'La descripción'),
                maxLines: 4,
              ),
              
              const SizedBox(height: AppTheme.spacingMedium),
              
              // Categoría
              Text(
                'Categoría',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppTheme.spacingSmall),
              
              Wrap(
                spacing: AppTheme.spacingSmall,
                runSpacing: AppTheme.spacingSmall,
                children: _categorias.map((cat) {
                  final isSelected = cat == _categoria;
                  return FilterChip(
                    label: Text(cat.replaceAll('_', ' ')),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _categoria = cat);
                    },
                    backgroundColor: Colors.grey.shade100,
                    selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                    checkmarkColor: AppTheme.primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: AppTheme.spacingMedium),
              
              ElegantFormField(
                label: 'Técnicas Utilizadas',
                hint: 'Ej: Acuarela, Lápiz, Digital...',
                prefixIcon: Icons.brush,
                controller: _tecnicasController,
              ),
              
              const SizedBox(height: AppTheme.spacingMedium),
              
              ElegantFormField(
                label: 'Software Utilizado',
                hint: 'Ej: Photoshop, Procreate, Illustrator...',
                prefixIcon: Icons.computer,
                controller: _softwareController,
              ),
              
              const SizedBox(height: AppTheme.spacingXLarge),
              
              // Botón de crear
              ElegantButton(
                text: 'Publicar Obra',
                onPressed: _isLoading ? null : _createPortfolio,
                type: ElegantButtonType.gradient,
                size: ElegantButtonSize.large,
                icon: Icons.publish,
                isLoading: _isLoading,
                fullWidth: true,
              ),
              
              const SizedBox(height: AppTheme.spacingMedium),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddImageButton() {
    return ElegantCard(
      onTap: _pickImages,
      type: ElegantCardType.outlined,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              size: 40,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: AppTheme.spacingSmall),
            Text(
              'Agregar',
              style: context.textTheme.bodySmall?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(int index) {
    return Stack(
      children: [
        ElegantCard(
          padding: EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
            child: Image.file(
              File(_selectedImages[index].path),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
