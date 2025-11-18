import 'package:flutter/material.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  // Estado para rastrear el plan de suscripción seleccionado por el usuario.
  String _selectedPlan = 'Freemium'; 
  final String _freemiumPlanName = 'Freemium';
  final String _premiumPlanName = 'Premium';
  final String _enterprisePlanName = 'Empresa';

  // Lógica para actualizar el estado del plan seleccionado.
  void _selectPlan(String planName) {
    setState(() {
      _selectedPlan = planName;
    });
    debugPrint('Plan seleccionado: $planName');
  }

  // Helper method para construir la tarjeta de cada plan de suscripción.
  Widget _buildSubscriptionCard(
    BuildContext context, {
    required String planName,
    required String price,
    required String pricePer,
    required List<String> features,
    required bool isSelected,
    required VoidCallback onTap,
    bool isRecommended = false,
    bool isEnterprise = false, // Para el botón "Hablar con ventas"
    String? subtitle, // Subtítulo opcional para el plan
  }) {
    // Definimos la paleta de MaterialColor completa (Colors.teal)
    final MaterialColor tealPalette = Colors.teal;
    // Definimos los colores específicos a usar
    final Color primaryColor = tealPalette.shade700;
    final Color accentColor = tealPalette.shade400;

    return Card(
      elevation: isSelected ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? primaryColor : Colors.grey.shade300,
          width: isSelected ? 3.0 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: isEnterprise ? null : onTap, // Deshabilita el InkWell para el plan Empresa
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Etiqueta "Recomendado"
              if (isRecommended)
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: primaryColor, // Fondo teal oscuro
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Recomendado',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              if (isRecommended) const SizedBox(height: 12),
              
              // Nombre del Plan
              Text(
                planName,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: tealPalette.shade900,
                ),
              ),
              const SizedBox(height: 4),

              // Precio
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: tealPalette.shade900,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    pricePer,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              
              // Lista de Características
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: features.map((feature) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Círculo para la selección
                        isSelected && !isEnterprise
                            ? Icon(Icons.radio_button_checked, color: primaryColor, size: 20)
                            : Icon(Icons.radio_button_unchecked, color: Colors.grey.shade400, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Botón de acción
              SizedBox(
                width: double.infinity,
                child: isEnterprise 
                    ? OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Contactando con ventas...'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryColor,
                          side: BorderSide(color: primaryColor, width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        child: const Text('Hablar con ventas'),
                      )
                    : ElevatedButton(
                        onPressed: onTap, // El onTap ya maneja la selección
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected ? accentColor : Colors.grey.shade200, // Color del botón
                          foregroundColor: isSelected ? tealPalette.shade900 : Colors.grey.shade700, // CORRECCIÓN
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          elevation: isSelected ? 4 : 0,
                        ),
                        child: Text(_selectedPlan == planName ? 'Plan Seleccionado' : 'Empezar'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Definimos la paleta de MaterialColor completa (Colors.teal)
    final MaterialColor tealPalette = Colors.teal;
    // Definimos los colores específicos a usar
    final Color primaryColor = tealPalette.shade700;
    final Color secondaryColor = tealPalette.shade200;

    return Scaffold(
      appBar: AppBar(
        title: const Text(''), // Título vacío en el AppBar para el diseño de la captura
        backgroundColor: Colors.transparent, // Fondo transparente para el AppBar
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Título principal
            Text(
              'Elige tu plan',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                // CORRECCIÓN: Usamos tealPalette para acceder a shade900
                color: tealPalette.shade900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Comienza gratis y mejora cuando necesites más visibilidad, métricas y soporte.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 32),

            // Tarjetas de Suscripción en una fila adaptable (o columna en pantallas pequeñas)
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 900) { // Para pantallas de escritorio
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildSubscriptionCard(
                          context,
                          planName: _freemiumPlanName,
                          price: 'S/. 0.00',
                          pricePer: 'cada mes',
                          features: [
                            'Perfil básico público',
                            'Recomendaciones de ofertas limitada',
                            'Soporte por correo (48h)',
                            'Portafolio con ilustraciones ilimitados'
                          ],
                          isSelected: _selectedPlan == _freemiumPlanName,
                          onTap: () => _selectPlan(_freemiumPlanName),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildSubscriptionCard(
                          context,
                          planName: _premiumPlanName,
                          price: 'S/. 50.00',
                          pricePer: 'cada mes',
                          subtitle: 'Ahorra tiempo con herramientas pro y mayor alcance.',
                          features: [
                            'Prioridad en búsquedas y listados',
                            'Recomendaciones ilimitados',
                            'Mensajería ilimitadas',
                            'Portafolio con ilustraciones ilimitadas',
                            'Estadísticas en tiempo real (impresiones, clics, leads)',
                            'Soporte prioritario',
                          ],
                          isSelected: _selectedPlan == _premiumPlanName,
                          onTap: () => _selectPlan(_premiumPlanName),
                          isRecommended: true,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildSubscriptionCard(
                          context,
                          planName: _enterprisePlanName,
                          price: 'S/. 199.00',
                          pricePer: 'cada mes',
                          subtitle: 'Para editoriales, agencias y equipos de contratación.',
                          features: [
                            'Convocatorias destacadas y marca empleadora',
                            'Integraciones (ATS/CRM) vía API',
                            'Reportes descargables y facturación',
                            'Gerente de cuenta dedicado',
                          ],
                          isSelected: _selectedPlan == _enterprisePlanName,
                          onTap: () => _selectPlan(_enterprisePlanName), // Aunque no se selecciona directamente, se mantiene para la estructura
                          isEnterprise: true,
                        ),
                      ),
                    ],
                  );
                } else { // Para pantallas móviles y tabletas
                  return Column(
                    children: [
                      _buildSubscriptionCard(
                        context,
                        planName: _freemiumPlanName,
                        price: 'S/. 0.00',
                        pricePer: 'cada mes',
                        features: [
                          'Perfil básico público',
                          'Recomendaciones de ofertas limitada',
                          'Soporte por correo (48h)',
                          'Portafolio con ilustraciones ilimitados'
                        ],
                        isSelected: _selectedPlan == _freemiumPlanName,
                        onTap: () => _selectPlan(_freemiumPlanName),
                      ),
                      const SizedBox(height: 20),
                      _buildSubscriptionCard(
                        context,
                        planName: _premiumPlanName,
                        price: 'S/. 50.00',
                        pricePer: 'cada mes',
                        subtitle: 'Ahorra tiempo con herramientas pro y mayor alcance.',
                        features: [
                          'Prioridad en búsquedas y listados',
                          'Recomendaciones ilimitados',
                          'Mensajería ilimitadas',
                          'Portafolio con ilustraciones ilimitadas',
                          'Estadísticas en tiempo real (impresiones, clics, leads)',
                          'Soporte prioritario',
                        ],
                        isSelected: _selectedPlan == _premiumPlanName,
                        onTap: () => _selectPlan(_premiumPlanName),
                        isRecommended: true,
                      ),
                      const SizedBox(height: 20),
                      _buildSubscriptionCard(
                        context,
                        planName: _enterprisePlanName,
                        price: 'S/. 199.00',
                        pricePer: 'cada mes',
                        subtitle: 'Para editoriales, agencias y equipos de contratación.',
                        features: [
                          'Convocatorias destacadas y marca empleadora',
                          'Integraciones (ATS/CRM) vía API',
                          'Reportes descargables y facturación',
                          'Gerente de cuenta dedicado',
                        ],
                        isSelected: _selectedPlan == _enterprisePlanName,
                        onTap: () => _selectPlan(_enterprisePlanName),
                        isEnterprise: true,
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}