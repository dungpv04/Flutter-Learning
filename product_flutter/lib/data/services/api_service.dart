import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client})
      : _client = client ?? http.Client();

  // Generic request method with error handling
  Future<Map<String, dynamic>> _makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? additionalHeaders,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final headers = {...ApiConstants.headers, ...?additionalHeaders};

    print('$method $url');
    if (body != null) print('Request body: $body');

    try {
      late http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await _client.get(url, headers: headers);
          break;
        case 'POST':
          response = await _client.post(
            url,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'PUT':
          response = await _client.put(
            url,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'DELETE':
          response = await _client.delete(url, headers: headers);
          break;
        default:
          throw UnsupportedError('HTTP method $method not supported');
      }

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on FormatException {
      throw const ServerException('Invalid response format');
    } catch (e) {
      print('Request failed: $e');
      rethrow;
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    switch (response.statusCode) {
      case 200:
      case 201:
        if (response.body.isEmpty) return {};
        try {
          return json.decode(response.body) as Map<String, dynamic>;
        } catch (e) {
          throw const ServerException('Invalid JSON response format');
        }
      case 204:
        return {};
      case 307:
      case 308:
        throw const ServerException('Redirect not handled - check API endpoint');
      case 400:
        throw const ValidationException('Bad request - check input data');
      case 401:
        throw const UnauthorizedException('Unauthorized access');
      case 404:
        throw const NotFoundException('Resource not found');
      case 500:
        throw const ServerException('Internal server error');
      default:
        throw ServerException('HTTP Error ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  Future<List<dynamic>> _makeListRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? additionalHeaders,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final headers = {...ApiConstants.headers, ...?additionalHeaders};

    print('$method $url');
    if (body != null) print('Request body: $body');

    try {
      late http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await _client.get(url, headers: headers);
          break;
        default:
          throw UnsupportedError('HTTP method $method not supported');
      }

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      switch (response.statusCode) {
        case 200:
          if (response.body.isEmpty) return [];
          try {
            return json.decode(response.body) as List<dynamic>;
          } catch (e) {
            throw const ServerException('Invalid JSON response format');
          }
        case 307:
        case 308:
          throw const ServerException('Redirect not handled - check API endpoint');
        case 400:
          throw const ValidationException('Bad request - check input data');
        case 401:
          throw const UnauthorizedException('Unauthorized access');
        case 404:
          throw const NotFoundException('Resource not found');
        case 500:
          throw const ServerException('Internal server error');
        default:
          throw ServerException('HTTP Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on FormatException {
      throw const ServerException('Invalid response format');
    } catch (e) {
      print('Request failed: $e');
      rethrow;
    }
  }

  // Product API methods
  Future<List<Product>> getProducts({int? skip, int? limit}) async {
    String endpoint = ApiConstants.products;
    if (skip != null || limit != null) {
      final params = <String, String>{};
      if (skip != null) params['skip'] = skip.toString();
      if (limit != null) params['limit'] = limit.toString();
      endpoint += '?${Uri(queryParameters: params).query}';
    }

    final response = await _makeListRequest('GET', endpoint);
    return response.map((json) => Product.fromJson(json)).toList();
  }

  Future<Product> getProduct(int id) async {
    final response = await _makeRequest('GET', '${ApiConstants.products}$id');
    return Product.fromJson(response);
  }

  Future<Product> createProduct(CreateProductRequest request) async {
    final response = await _makeRequest(
      'POST',
      ApiConstants.products,
      body: request.toJson(),
    );
    return Product.fromJson(response);
  }

  Future<Product> updateProduct(int id, UpdateProductRequest request) async {
    final response = await _makeRequest(
      'PUT',
      '${ApiConstants.products}$id',
      body: request.toJson(),
    );
    return Product.fromJson(response);
  }

  Future<void> deleteProduct(int id) async {
    await _makeRequest('DELETE', '${ApiConstants.products}$id');
  }

  void dispose() {
    _client.close();
  }
}
