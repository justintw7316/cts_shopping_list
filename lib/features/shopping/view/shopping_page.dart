// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/shopping_bloc.dart';
import '../bloc/shopping_state.dart';
import 'widgets/shopping_item_tile.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  late final SoundBoard _soundBoard;

  @override
  void initState() {
    super.initState();
    _soundBoard = SoundBoard();
  }

  @override
  void dispose() {
    _soundBoard.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShoppingCubit(),
      child: ShoppingView(
        soundBoard: _soundBoard,
      ),
    );
  }
}

class ShoppingView extends StatelessWidget {
  const ShoppingView({super.key, required this.soundBoard});

  final SoundBoard soundBoard;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 247, 247, 242)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const _ShoppingSliverAppBar(),
              BlocBuilder<ShoppingCubit, ShoppingState>(
                buildWhen: (previous, current) =>
                    previous.total != current.total ||
                    previous.selectedIds.length != current.selectedIds.length,
                builder: (context, state) {
                  return SliverPersistentHeader(
                    pinned: true,
                    delegate: _TotalHeaderDelegate(
                      total: state.total,
                      selectedCount: state.selectedIds.length,
                      colorScheme: colorScheme,
                    ),
                  );
                },
              ),
              BlocBuilder<ShoppingCubit, ShoppingState>(
                builder: (context, state) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = state.items[index];
                        final isSelected =
                            state.selectedIds.contains(item.id);
                        return ShoppingItemTile(
                          item: item,
                          isSelected: isSelected,
                          onToggle: () {
                            if (isSelected) {
                              soundBoard.playDeselect();
                            } else {
                              soundBoard.playSelect();
                            }
                            context
                                .read<ShoppingCubit>()
                                .toggleItem(item.id);
                          },
                        );
                      },
                      childCount: state.items.length,
                    ),
                  );
                },
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShoppingSliverAppBar extends StatelessWidget {
  const _ShoppingSliverAppBar();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      floating: true,
      pinned: true,
      expandedHeight: 160,
      backgroundColor: colorScheme.surface,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsetsDirectional.only(
          start: 16,
          bottom: 16,
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Shopping List',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
            Text(
              'What are we buying today?',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    // ignore: deprecated_member_use
                    colorScheme.primary.withOpacity(0.14),
                    colorScheme.secondary.withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(
                  Icons.shopping_basket_outlined,
                  size: 48,
                  color: colorScheme.primary.withOpacity(0.35),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalHeaderDelegate extends SliverPersistentHeaderDelegate {
  _TotalHeaderDelegate({
    required this.total,
    required this.selectedCount,
    required this.colorScheme,
  });

  final double total;
  final int selectedCount;
  final ColorScheme colorScheme;
  final NumberFormat _currency = NumberFormat.simpleCurrency();

  @override
  double get minExtent => 96;

  @override
  double get maxExtent => 96;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selected',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$selectedCount item${selectedCount == 1 ? '' : 's'}',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _currency.format(total),
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _TotalHeaderDelegate oldDelegate) {
    return total != oldDelegate.total ||
        selectedCount != oldDelegate.selectedCount;
  }
}

class SoundBoard {
  SoundBoard() {
    _selectPlayer.setReleaseMode(ReleaseMode.stop);
    _deselectPlayer.setReleaseMode(ReleaseMode.stop);
  }

  final AudioPlayer _selectPlayer = AudioPlayer();
  final AudioPlayer _deselectPlayer = AudioPlayer();

  Future<void> playSelect() async {
    await _selectPlayer
        .play(AssetSource('audio/mixkit-achievement-bell-600.wav'));
  }

  Future<void> playDeselect() async {
    await _deselectPlayer.play(AssetSource('audio/deselection.wav'));
  }

  void dispose() {
    unawaited(_selectPlayer.dispose());
    unawaited(_deselectPlayer.dispose());
  }
}
