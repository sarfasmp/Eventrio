import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:event_and_voucher/services/voucher_service.dart';
import 'package:event_and_voucher/widgets/voucher_card.dart';
import 'package:event_and_voucher/theme/app_theme.dart';

class VouchersScreen extends StatefulWidget {
  const VouchersScreen({super.key});

  @override
  State<VouchersScreen> createState() => _VouchersScreenState();
}

class _VouchersScreenState extends State<VouchersScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Dining',
    'Shopping',
    'Wellness',
    'Entertainment',
    'Fitness',
    'Beauty',
  ];

  @override
  Widget build(BuildContext context) {
    final vouchers = _selectedCategory == 'All'
        ? VoucherService.getAllVouchers()
        : VoucherService.getVouchersByCategory(_selectedCategory);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Vouchers',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.orangeGradient,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = category == _selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          selectedColor: AppTheme.accentColor.withValues(alpha: 0.2),
                          checkmarkColor: AppTheme.accentColor,
                          labelStyle: TextStyle(
                            color: isSelected ? AppTheme.accentColor : Colors.grey[700],
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          vouchers.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.card_giftcard,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No vouchers found',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final voucher = vouchers[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: VoucherCard(
                            voucher: voucher,
                            onTap: () {
                              context.go('/voucher/${voucher.id}');
                            },
                          ),
                        );
                      },
                      childCount: vouchers.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
