namespace TeamTaskManager.DTO.Common;

public class ApiErrorResponse
{
    public required string Title { get; set; }
    public int StatusCode { get; set; }
    public List<string> Errors { get; set; } = new();
    public string? TraceId { get; set; }
}