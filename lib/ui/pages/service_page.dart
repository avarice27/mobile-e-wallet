import 'package:bank_sha_rafi/models/service_form_model.dart';
import 'package:bank_sha_rafi/shared/theme.dart';
import 'package:bank_sha_rafi/ui/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bank_sha_rafi/blocs/service_form/service_form_bloc.dart';
import 'package:bank_sha_rafi/blocs/auth/auth_bloc.dart';
import 'package:bank_sha_rafi/shared/theme.dart';
import 'package:bank_sha_rafi/shared/helpers.dart';
import 'package:bank_sha_rafi/ui/pages/service_payment_page.dart';
import 'package:bank_sha_rafi/ui/pages/pin_page.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  ServiceModel? selectedService;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceBloc()..add(ServiceGet()),
      child: BlocConsumer<ServiceBloc, ServiceState>(
        listener: (context, state) {
          if (state is ServiceError) {
            showCustomSnackbar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is ServiceLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is ServiceLoaded) {
            // Debug prints
            print('Total services loaded: ${state.services.length}');
            state.services.forEach((service) {
              print('Service: ${service.name} - Role: ${service.roleId}');
            });

            // Show all services for now until we confirm role filtering works
            final filteredServices = state.services;

            return Scaffold(
              appBar: AppBar(
                title: const Text('Services'),
              ),
              body: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                children: [
                  const SizedBox(height: 30),
                  Wrap(
                    spacing: 17,
                    runSpacing: 17,
                    children: filteredServices.map((service) {
                      final isSelected =
                          selectedService?.name == service.name &&
                              selectedService?.price == service.price;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedService = service;
                          });
                        },
                        child: Container(
                          width: 155,
                          height: 110,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 22,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? purpleColor : whiteColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? purpleColor : greyColor,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                service.name,
                                style: blackTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: medium,
                                  color: isSelected ? whiteColor : blackColor,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                formatCurrency(service.price),
                                style: greyTextStyle.copyWith(
                                  fontSize: 12,
                                  color: isSelected ? whiteColor : greyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 57),
                ],
              ),
              // Inside your ServicePage's floatingActionButton
              floatingActionButton: selectedService != null
                  ? Container(
                      margin: const EdgeInsets.all(24),
                      child: CustomFilledButton(
                        title: 'Continue',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServicePaymentPage(
                                selectedService: selectedService!,
                              ),
                            ),
                          ).then((value) {
                            if (value == true) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PinPage(),
                                ),
                              );
                            }
                          });
                        },
                      ),
                    )
                  : Container(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            );
          }

          return const Scaffold(
            body: Center(
              child: Text('No services available'),
            ),
          );
        },
      ),
    );
  }
}