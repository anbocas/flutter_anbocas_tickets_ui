import 'package:anbocas_tickets_ui/src/helper/api_exception_utils.dart';
import 'package:anbocas_tickets_ui/src/helper/logger_utils.dart';
import 'package:anbocas_tickets_ui/src/model/api_response.dart';
import 'package:anbocas_tickets_ui/src/model/company_overview_response.dart';
import 'package:anbocas_tickets_ui/src/service/anbocas_service.dart';
import 'package:dio/dio.dart';

const _companyOverViewUrl = "/v1/company/overview";

class AnbocasCompanyOverviewRepo extends AnbocasService with LoggerUtils {
  AnbocasCompanyOverviewRepo({
    required String baseUrl,
    Dio? dio,
    Map<String, String>? apiHeaders,
  }) : super(dio: dio, baseUrl: baseUrl, apiHeaders: apiHeaders);

  Future<ApiResponse<CompanyOverviewResponse>> getCompanyOverview({
    required String companyId,
  }) async {
    try {
      var resp = await doGet(_companyOverViewUrl,
          queryParameters: {"company_id": companyId});
      info("$companyId -- ${resp.data}");
      if (resp.data['data'] != null) {
        var companyResp = CompanyOverviewResponse.fromJson(resp.data['data']);

        return ApiResponse(data: companyResp);
      } else {
        return ApiResponse(error: "Tickets Not Found");
      }
    } on Exception catch (e) {
      return ApiResponse(error: handleAnbocasApiException(e));
    }
  }
}
