import 'package:bank_sha_rafi/blocs/auth/auth_bloc.dart';
import 'package:bank_sha_rafi/blocs/payment_method/payment_method_bloc.dart';
import 'package:bank_sha_rafi/blocs/service_form/service_form_bloc.dart';
import 'package:bank_sha_rafi/models/payment_method_model.dart';
import 'package:bank_sha_rafi/models/service_form_model.dart';
import 'package:bank_sha_rafi/models/topup_form_model.dart';
import 'package:bank_sha_rafi/shared/theme.dart';
import 'package:bank_sha_rafi/shared/helpers.dart';
import 'package:bank_sha_rafi/ui/pages/topup_amount_page.dart';
import 'package:bank_sha_rafi/ui/widgets/bank_item.dart';
import 'package:bank_sha_rafi/ui/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServicePaymentPage extends StatefulWidget {
  final ServiceModel selectedService;

  const ServicePaymentPage({
    Key? key,
    required this.selectedService,
  }) : super(key: key);

  @override
  State<ServicePaymentPage> createState() => _ServicePaymentPageState();
}

class _ServicePaymentPageState extends State<ServicePaymentPage> {
  PaymentMethodModel? selectedPaymentMethod;
  ServiceModel? selectedRoleId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Service Payment',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        children: [
          const SizedBox(
            height: 30,
          ),
          Text(
            'Selected Service',
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: greyColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.selectedService.name,
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: medium,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  formatCurrency(widget.selectedService.price),
                  style: greyTextStyle.copyWith(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            'Wallet',
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthSuccess) {
                return Row(
                  children: [
                    Image.asset(
                      'assets/img_wallet.png',
                      width: 80,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.data.cardNumber!.replaceAllMapped(
                              RegExp(r".{4}"), (match) => "${match.group(0)} "),
                          style: blackTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: medium,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          state.data.name!,
                          style: greyTextStyle.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            'Select Payment Method',
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          BlocProvider(
            create: (context) => PaymentMethodBloc()..add(PaymentMethodGet()),
            child: BlocBuilder<PaymentMethodBloc, PaymentMethodState>(
              builder: (context, state) {
                if (state is PaymentMethodSuccess) {
                  return Column(
                    children: state.data.map((paymentMethod) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPaymentMethod = paymentMethod;
                          });
                        },
                        child: BankItem(
                          data: paymentMethod,
                          isSelected:
                              paymentMethod.id == selectedPaymentMethod?.id,
                        ),
                      );
                    }).toList(),
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          if (selectedPaymentMethod != null)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: CustomFilledButton(
                title: 'Continue',
                onPressed: () async {
                  if (await Navigator.pushNamed(context, '/pin') == true) {
                    final authState = context.read<AuthBloc>().state;
                    String pin = '';
                    if (authState is AuthSuccess) {
                      pin = authState.data.pin!;
                    }

                    context.read<ServiceBloc>().add(
                          ServiceFormPost(
                            widget.selectedService.copyWith(
                              pin: pin,
                              paymentMethodId: selectedPaymentMethod?.id,
                              roleId: selectedRoleId?.roleId,
                              amount: widget.selectedService.price.toString(),
                            ),
                          ),
                        );

                    // Optionally, navigate to a confirmation or success page
                    Navigator.pushReplacementNamed(context, '/service-success');
                  }
                },
              ),
            ),
          const SizedBox(
            height: 57,
          ),
        ],
      ),
    );
  }
}
