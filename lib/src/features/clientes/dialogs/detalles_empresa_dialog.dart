import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';

class DetallesEmpresaDialog extends StatefulWidget {
  final Map<String, dynamic> cliente;

  const DetallesEmpresaDialog({
    super.key,
    required this.cliente,
  });

  @override
  State<DetallesEmpresaDialog> createState() => _DetallesEmpresaDialogState();
}

class _DetallesEmpresaDialogState extends State<DetallesEmpresaDialog> {
  late final Supabase _supabase = Supabase.instance;

  Future<Map<String, dynamic>?> _obtenerEmpresa(String adminId) async {
    try {
      final response = await _supabase.client
          .from('empresas')
          .select()
          .eq('admin_id', adminId)
          .maybeSingle();
      return response;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cliente = widget.cliente;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      elevation: 8,
      title: Container(
        padding: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.blue.shade100, width: 2)),
        ),
        child: Row(
          children: [
            Icon(Icons.person_rounded, color: AppColors.primaryBlue, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detalles de la Empresa',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cliente['full_name'] ?? 'Sin nombre',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: isSmallScreen ? double.maxFinite : 400,
          child: FutureBuilder<Map<String, dynamic>?>(
            future: _obtenerEmpresa(cliente['id'] ?? ''),
            builder: (context, snapshot) {
              final empresa = snapshot.data;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDetailSection('Información del Usuario', [
                    _buildDetailRow('Nombre Completo', cliente['full_name'] ?? 'No disponible'),
                    _buildDetailRow('Email', cliente['email'] ?? 'No disponible'),
                    _buildDetailRow('Teléfono', cliente['phone'] ?? 'No disponible'),
                    _buildDetailRow('Rol', cliente['role'] ?? 'No disponible'),
                  ]),
                  const SizedBox(height: 20),
                  if (empresa != null) ...[
                    _buildDetailSection('Información de la Empresa', [
                      _buildDetailRow('Nombre del Negocio', empresa['nombre_negocio'] ?? 'No disponible'),
                      _buildDetailRow('Sector', empresa['sector'] ?? 'No disponible'),
                      _buildDetailRow('Teléfono de Negocio', empresa['telefono'] ?? 'No disponible'),
                      _buildDetailRow('Email de Negocio', empresa['email_negocio'] ?? 'No disponible'),
                    ]),
                    const SizedBox(height: 20),
                    _buildDetailSection('Ubicación', [
                      _buildDetailRow('Dirección', empresa['direccion'] ?? 'No disponible'),
                      _buildDetailRow('Ciudad', empresa['ciudad'] ?? 'No disponible'),
                      _buildDetailRow('Provincia', empresa['provincia'] ?? 'No disponible'),
                      _buildDetailRow('Código Postal', empresa['codigo_postal'] ?? 'No disponible'),
                    ]),
                  ] else if (snapshot.connectionState == ConnectionState.waiting)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: CircularProgressIndicator(),
                    )
                  else
                    const Text('No se encontró información de la empresa'),
                ],
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? 'No disponible',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

