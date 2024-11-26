import 'package:anbocas_tickets_ui/src/helper/api_exception_utils.dart';
import 'package:anbocas_tickets_ui/src/helper/logger_utils.dart';
import 'package:anbocas_tickets_ui/src/model/api_response.dart';
import 'package:anbocas_tickets_ui/src/model/coupon_model.dart';
import 'package:anbocas_tickets_ui/src/model/order_response.dart';
import 'package:anbocas_tickets_ui/src/model/single_ticket.dart';
import 'package:anbocas_tickets_ui/src/model/anbocas_event_response.dart';
import 'package:anbocas_tickets_ui/src/service/anbocas_service.dart';
import 'package:dio/dio.dart';

// const _ticketByEventUrl = "/v1/ticketsByEvent";
const _ticketsUrl = "/v1/event";
const _placeOrderUrl = "/v1/orders/placeOrder";
// const _orderDetailsUrl = "/v1/orders/";
const _getCalculateAmountUrl = "/v1/orders/calculate";
const _validateCouponUrl = "/v1/coupons/validate";
const _verifyOrderPaymentUrl = "/v1/verifyOrderPayment";
const _cancelOrderPaymentUrl = "/v1/order/cancel";
const _listOrderEmail = "/v1/ordersByEmail";

class AnbocasBookingRepo extends AnbocasService with LoggerUtils {
  AnbocasBookingRepo({
    required String baseUrl,
    Dio? dio,
    Map<String, String>? apiHeaders,
  }) : super(dio: dio, baseUrl: baseUrl, apiHeaders: apiHeaders);

  Future<ApiResponse<AnbocasEventResponse>> getEventById({
    required String eventId,
  }) async {
    try {
      var resp = await doGet("$_ticketsUrl/$eventId",
          queryParameters: {"paginate": false});
      info("$eventId -- ${resp.data}");
      if (resp.data['data'] != null) {
        DateTime now = DateTime.now();
        var ticketResp = AnbocasEventResponse.fromJson(resp.data['data']);
        List<SingleTicket> validTickets = [];
        validTickets.clear();
        for (var ticket in ticketResp.tickets) {
          DateTime? availableFrom = ticket.availableFrom != null
              ? DateTime.parse(ticket.availableFrom!)
              : null;
          DateTime? availableTo = ticket.availableTo != null
              ? DateTime.parse(ticket.availableTo!)
              : null;
          bool isAvailable =
              (availableFrom == null || now.isAfter(availableFrom)) &&
                  (availableTo == null || now.isBefore(availableTo));

          if (isAvailable) {
            validTickets.add(ticket);
          }
        }
        return ApiResponse(data: ticketResp.copyWith(tickets: validTickets));
      } else {
        return ApiResponse(error: "Tickets Not Found");
      }
    } on Exception catch (e) {
      return ApiResponse(error: handleAnbocasApiException(e));
    }
  }

  Future<ApiResponse<AnbocasOrderResponse>> placeOrder(
      {required List<SingleTicket> selectedTickets,
      String? coupon,
      required String name,
      String? phone,
      required String email,
      bool isGuestCheckout = false,
      bool shouldGeneratePaymentLink = true}) async {
    List<Map<String, dynamic>> selectedTicket = [];
    selectedTickets.asMap().forEach((index, value) {
      var singleTicket = <String, dynamic>{};
      singleTicket.putIfAbsent("id", () => value.id);
      singleTicket.putIfAbsent("quantity", () => value.selectedQuantity);
      selectedTicket.add(singleTicket);
    });
    var data = {
      "event_id": selectedTickets.first.eventId,
      "tickets": selectedTicket,
      "coupon": coupon,
      "name": name,
      "phone": phone,
      "email": email,
      "is_guest_checkout": isGuestCheckout,
      "payment_link_required": shouldGeneratePaymentLink ? '1' : '0',
    };

    info(data.toString());
    try {
      var resp = await doPost(_placeOrderUrl, data);
      info(resp.data.toString());
      if (resp.data['data'] != null) {
        var order = AnbocasOrderResponse.fromJson(resp.data);
        return ApiResponse(data: order);
      } else {
        return ApiResponse(error: "Order not Found");
      }
    } on Exception catch (e) {
      return ApiResponse(error: handleAnbocasApiException(e));
    }
  }

  Future<ApiResponse<OrderData>> getOrderDetails(
      {required String orderId}) async {
    try {
      Options options = Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });
      var resp = await doGet("/v1/orders/$orderId", options: options);
      info(resp.data.toString());
      if (resp.data['data'] != null) {
        var order = OrderData.fromJson(resp.data['data']);
        return ApiResponse(data: order);
      } else {
        return ApiResponse(error: "Order Not Found");
      }
    } on Exception catch (e) {
      return ApiResponse(error: handleAnbocasApiException(e));
    }
  }

  Future<ApiResponse<AnbocasOrderResponse>> getCalculateAmount({
    required List<SingleTicket> selectedTickets,
    String? coupon,
  }) async {
    List<Map<String, dynamic>> selectedTicket = [];
    selectedTickets.asMap().forEach((index, value) {
      var singleTicket = <String, dynamic>{};
      singleTicket.putIfAbsent("id", () => value.id);
      singleTicket.putIfAbsent("quantity", () => value.selectedQuantity);
      selectedTicket.add(singleTicket);
    });
    var data = {
      "event_id": selectedTickets.first.eventId,
      "tickets": selectedTicket,
      "coupon": coupon,
    };

    try {
      info(data.toString());
      var resp = await doPost(_getCalculateAmountUrl, data);
      info(resp.data.toString());
      if (resp.data['data'] != null) {
        var order = AnbocasOrderResponse.fromJson(resp.data);
        return ApiResponse(data: order);
      } else {
        return ApiResponse(error: "Order data Not found");
      }
    } on Exception catch (e) {
      return ApiResponse(error: handleAnbocasApiException(e));
    }
  }

  Future<ApiResponse<CouponModel>> validateCoupon(
      {required String code, required String eventId}) async {
    try {
      info("$code - $eventId");
      var resp =
          await doPost(_validateCouponUrl, {"code": code, "event_id": eventId});
      if (resp.data['data'] != null) {
        return ApiResponse(data: CouponModel.fromJson(resp.data['data']));
      } else {
        return ApiResponse(error: "Not Valid Coupon");
      }
    } on Exception catch (e) {
      return ApiResponse(error: handleAnbocasApiException(e));
    }
  }

  Future<bool> verifyOrderPayment(
    String paymentId,
  ) async {
    try {
      await doPost(_verifyOrderPaymentUrl, {"razorpay_payment_id": paymentId});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> cancelOrder(
    String orderId,
  ) async {
    try {
      await doPost(_cancelOrderPaymentUrl, {"order_id": orderId});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<ApiResponse<List<OrderData>>> getOrderByEmail(
      {required String email, int pageNo = 1}) async {
    try {
      Options options = Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });
      var resp =
          await doGet(_listOrderEmail, options: options, queryParameters: {
        "email": email,
      });
      info(resp.data.toString());
      if (resp.data['data'] != null) {
        var orders = (resp.data['data'] as List)
            .map((item) => OrderData.fromJson(item))
            .toList();
        return ApiResponse(data: orders);
      } else {
        return ApiResponse(error: "Order Not Found");
      }
    } on Exception catch (e) {
      return ApiResponse(error: handleAnbocasApiException(e));
    }
  }
}
