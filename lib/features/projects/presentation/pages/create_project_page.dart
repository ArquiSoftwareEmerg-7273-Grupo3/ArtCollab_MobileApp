import 'package:flutter/material.dart';
import 'package:artcollab_mobile/features/projects/data/remote/project_service.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';
import 'package:artcollab_mobile/core/theme/app_theme.dart';
import 'package:artcollab_mobile/shared/widgets/elegant_form_field.dart';
import 'package:artcollab_mobile/shared/widgets/elegant_button.dart';
import 'package:artcollab_mobile/shared/widgets/elegant_card.dart';
extension DateTimeBackendFormat on DateTime {
  String toBackendFormat() {
    // formato EXACTO que acepta tu backend
    return "${year.toString().padLeft(4, '0')}"
           "-${month.toString().padLeft(2, '0')}"
           "-${day.toString().padLeft(2, '0')}"
           "T${hour.toString().padLeft(2, '0')}"
           ":${minute.toString().padLeft(2, '0')}"
           ":${second.toString().padLeft(2, '0')}";
  }
}

class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({super.key});

  @override
  State<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  final _formKey = GlobalKey<FormState>();
  final ProjectService _projectService = ProjectService();
  
  // Controllers
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _presupuestoController = TextEditingController();
  final _requisitosController = TextEditingController();
  final _maxPostulacionesController = TextEditingController(text: '10');
  
  // State
  bool _isLoading = false;
  String _modalidadProyecto = 'REMOTO';
  String _contratoProyecto = 'FREELANCE';
  String _especialidadProyecto = 'ILUSTRACION_DIGITAL';
  DateTime _fechaInicio = DateTime.now();
  DateTime _fechaFin = DateTime.now().add(const Duration(days: 30));
  
  final List<String> _modalidades = ['REMOTO', 'PRESENCIAL', 'HIBRIDO'];
  final List<String> _contratos = ['FREELANCE', 'TIEMPO_COMPLETO', 'MEDIO_TIEMPO', 'POR_PROYECTO'];
  final List<String> _especialidades = [
    'ILUSTRACION_DIGITAL',
    'ILUSTRACION_TRADICIONAL', 
    'ARTE_VECTORIAL',
    'ANIMACION',
    'CONCEPT_ART',
    'ARTE_3D',
    'COMIC_MANGA'
  ];

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _presupuestoController.dispose();
    _requisitosController.dispose();
    _maxPostulacionesController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  DateTime cleanDate(DateTime date) {
  return DateTime(
    date.year,
    date.month,
    date.day,
    date.hour,
    date.minute,
    date.second,
  );
}
DateTime toBackendDate(DateTime d) {
  final formatted = d.toBackendFormat();
  return DateTime.parse(formatted);
}



  String? _validatePresupuesto(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El presupuesto es requerido';
    }
    final presupuesto = double.tryParse(value);
    if (presupuesto == null || presupuesto <= 0) {
      return 'Ingrese un presupuesto válido';
    }
    return null;
  }

  String? _validateMaxPostulaciones(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El número máximo de postulaciones es requerido';
    }
    final max = int.tryParse(value);
    if (max == null || max <= 0 || max > 100) {
      return 'Ingrese un número entre 1 y 100';
    }
    return null;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _fechaInicio : _fechaFin,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _fechaInicio = picked;
          if (_fechaFin.isBefore(_fechaInicio)) {
            _fechaFin = _fechaInicio.add(const Duration(days: 7));
          }
        } else {
          _fechaFin = picked;
        }
      });
    }
  }

  Future<void> _createProject() async {
    if (!_formKey.currentState!.validate()) {
      debugPrint('❌ Validación de formulario falló');
      return;
    }

    
    
    setState(() => _isLoading = true);
    
    try {
      debugPrint('📤 Iniciando creación de proyecto...');
      debugPrint('Título: ${_tituloController.text.trim()}');
      debugPrint('Presupuesto: ${_presupuestoController.text}');
      debugPrint('Modalidad: $_modalidadProyecto');
      debugPrint('Contrato: $_contratoProyecto');
      debugPrint('Especialidad: $_especialidadProyecto');
      debugPrint('Fecha Inicio: $_fechaInicio');
      debugPrint('Fecha Fin: $_fechaFin');
      debugPrint('Max Postulaciones: ${_maxPostulacionesController.text}');
      
      final result = await _projectService.createProject(
        titulo: _tituloController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        presupuesto: double.parse(_presupuestoController.text),
        modalidadProyecto: _modalidadProyecto,
        contratoProyecto: _contratoProyecto,
        especialidadProyecto: _especialidadProyecto,
        requisitos: _requisitosController.text.trim().isNotEmpty 
            ? _requisitosController.text.trim() 
            : 'Sin requisitos específicos',
        fechaInicio: toBackendDate(_fechaInicio),
fechaFin: toBackendDate(_fechaFin),


        maxPostulaciones: int.parse(_maxPostulacionesController.text),
      );
      
      debugPrint('📥 Respuesta recibida: ${result.runtimeType}');
      
      if (result is Success && mounted) {
        debugPrint('✅ Proyecto creado exitosamente');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: AppTheme.spacingSmall),
                Text('Proyecto creado exitosamente'),
              ],
            ),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.pop(context, true);
      } else if (mounted) {
        final errorMessage = result is Error ? (result.message ?? 'Error desconocido') : 'Error al crear proyecto';
        debugPrint('❌ Error al crear proyecto: $errorMessage');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: AppTheme.spacingSmall),
                Expanded(
                  child: Text(errorMessage),
                ),
              ],
            ),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
            ),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Ver Detalles',
              textColor: Colors.white,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error Detallado'),
                    content: SingleChildScrollView(
                      child: Text(errorMessage),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cerrar'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Excepción capturada: $e');
      debugPrint('Stack trace: $stackTrace');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.error, color: Colors.white),
                    SizedBox(width: AppTheme.spacingSmall),
                    Text('Error Inesperado'),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingXSmall),
                Text(
                  e.toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
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
        title: const Text('Crear Proyecto'),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppTheme.spacingSmall),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                          ),
                          child: const Icon(
                            Icons.work_outline,
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
                                'Nuevo Proyecto',
                                style: context.textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: AppTheme.spacingXSmall),
                              Text(
                                'Completa la información para publicar tu proyecto',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppTheme.spacingLarge),
              
              // Información básica
              Text(
                'Información Básica',
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              
              ElegantFormField(
                label: 'Título del Proyecto',
                hint: 'Ej: Ilustraciones para libro infantil',
                prefixIcon: Icons.title,
                controller: _tituloController,
                validator: (value) => _validateRequired(value, 'El título'),
              ),
              
              const SizedBox(height: AppTheme.spacingMedium),
              
              ElegantFormField(
                label: 'Descripción',
                hint: 'Describe detalladamente el proyecto...',
                prefixIcon: Icons.description,
                controller: _descripcionController,
                validator: (value) => _validateRequired(value, 'La descripción'),
                maxLines: 4,
              ),
              
              const SizedBox(height: AppTheme.spacingMedium),
              
              Row(
                children: [
                  Expanded(
                    child: ElegantFormField(
                      label: 'Presupuesto (USD)',
                      hint: '0.00',
                      prefixIcon: Icons.attach_money,
                      controller: _presupuestoController,
                      validator: _validatePresupuesto,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMedium),
                  Expanded(
                    child: ElegantFormField(
                      label: 'Máx. Postulaciones',
                      hint: '10',
                      prefixIcon: Icons.people,
                      controller: _maxPostulacionesController,
                      validator: _validateMaxPostulaciones,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacingMedium),
              
              ElegantFormField(
                label: 'Requisitos (Opcional)',
                hint: 'Especifica los requisitos del proyecto...',
                prefixIcon: Icons.checklist,
                controller: _requisitosController,
                maxLines: 3,
              ),
              
              const SizedBox(height: AppTheme.spacingLarge),
              
              // Detalles del proyecto
              Text(
                'Detalles del Proyecto',
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              
              // Modalidad
              _buildSectionTitle('Modalidad de Trabajo'),
              _buildRadioGroup(_modalidades, _modalidadProyecto, (value) {
                setState(() => _modalidadProyecto = value);
              }),
              
              const SizedBox(height: AppTheme.spacingMedium),
              
              // Tipo de contrato
              _buildSectionTitle('Tipo de Contrato'),
              _buildRadioGroup(_contratos, _contratoProyecto, (value) {
                setState(() => _contratoProyecto = value);
              }),
              
              const SizedBox(height: AppTheme.spacingMedium),
              
              // Especialidad
              _buildSectionTitle('Especialidad Requerida'),
              _buildRadioGroup(_especialidades, _especialidadProyecto, (value) {
                setState(() => _especialidadProyecto = value);
              }),
              
              const SizedBox(height: AppTheme.spacingMedium),
              
              // Fechas
              _buildSectionTitle('Fechas del Proyecto'),
              Row(
                children: [
                  Expanded(
                    child: _buildDateCard(
                      'Fecha de Inicio',
                      _fechaInicio,
                      Icons.calendar_today,
                      () => _selectDate(context, true),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMedium),
                  Expanded(
                    child: _buildDateCard(
                      'Fecha de Fin',
                      _fechaFin,
                      Icons.event,
                      () => _selectDate(context, false),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacingXLarge),
              
              // Botón de crear
              ElegantButton(
                text: 'Crear Proyecto',
                onPressed: _isLoading ? null : _createProject,
                type: ElegantButtonType.gradient,
                size: ElegantButtonSize.large,
                icon: Icons.add_circle_outline,
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSmall),
      child: Text(
        title,
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildRadioGroup(
    List<String> options,
    String groupValue,
    Function(String) onChanged,
  ) {
    return ElegantCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          return Column(
            children: [
              RadioListTile<String>(
                title: Text(
                  option.replaceAll('_', ' '),
                  style: context.textTheme.bodyMedium,
                ),
                value: option,
                groupValue: groupValue,
                onChanged: (value) => onChanged(value!),
                activeColor: AppTheme.primaryColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMedium,
                ),
              ),
              if (index < options.length - 1)
                Divider(height: 1, color: Colors.grey.shade200),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDateCard(
    String label,
    DateTime date,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ElegantCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: AppTheme.spacingSmall),
              Text(
                label,
                style: context.textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSmall),
          Text(
            '${date.day}/${date.month}/${date.year}',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
