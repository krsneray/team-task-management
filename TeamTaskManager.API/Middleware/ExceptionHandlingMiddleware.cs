using System.Net;
using System.Text.Json;
using TeamTaskManager.DTO.Common;

namespace TeamTaskManager.API.Middleware;

public class ExceptionHandlingMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<ExceptionHandlingMiddleware> _logger;

    public ExceptionHandlingMiddleware(RequestDelegate next, ILogger<ExceptionHandlingMiddleware> logger)
    {
        _next = next;
        _logger = logger;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await _next(context);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Beklenmeyen bir hata oluştu.");

            context.Response.ContentType = "application/json";
            context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;

            var response = new ApiErrorResponse
            {
                Title = "Sunucuda beklenmeyen bir hata oluştu.",
                StatusCode = context.Response.StatusCode,
                Errors = new List<string> { "Lütfen daha sonra tekrar deneyin." },
                TraceId = context.TraceIdentifier
            };

            var json = JsonSerializer.Serialize(response);
            await context.Response.WriteAsync(json);
        }
    }
}