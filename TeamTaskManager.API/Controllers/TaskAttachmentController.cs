using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using TeamTaskManager.Business;
using TeamTaskManager.DTO;
using TeamTaskManager.DTO.Common;

namespace TeamTaskManager.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class TaskAttachmentController : ControllerBase
{
    private readonly TaskAttachmentService _attachmentService;
    private readonly IWebHostEnvironment _environment;

    public TaskAttachmentController(
        TaskAttachmentService attachmentService,
        IWebHostEnvironment environment)
    {
        _attachmentService = attachmentService;
        _environment = environment;
    }

    [HttpPost("upload/{taskItemId}")]
    [Consumes("multipart/form-data")]
    public async Task<ActionResult<TaskAttachmentResponseDto>> UploadFile(
        int taskItemId,
        IFormFile file)
    {
        var currentUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (currentUserId == null)
            return Unauthorized();

        if (file == null || file.Length == 0)
            return BadRequest(new ApiErrorResponse { Title = "Hata", StatusCode = 400, Errors = new List<string> { "Dosya seçilmedi." } });

        var uploadsFolder = Path.Combine(_environment.ContentRootPath, "Uploads");

        if (!Directory.Exists(uploadsFolder))
        {
            Directory.CreateDirectory(uploadsFolder);
        }

        var extension = Path.GetExtension(file.FileName);

        var storedFileName = Guid.NewGuid().ToString() + extension;

        var filePath = Path.Combine(uploadsFolder, storedFileName);

        using (var stream = new FileStream(filePath, FileMode.Create))
        {
            await file.CopyToAsync(stream);
        }

        var result = await _attachmentService.AddAttachmentAsync(
            taskItemId,
            file.FileName,
            storedFileName,
            filePath,
            file.ContentType,
            file.Length,
            currentUserId);

        if (result == null)
        {
            try
            {
                if (System.IO.File.Exists(filePath))
                {
                    System.IO.File.Delete(filePath);
                }
            }
            catch
            {
            }

            return BadRequest(new ApiErrorResponse { Title = "Hata", StatusCode = 400, Errors = new List<string> { "Görev bulunamadı veya bu projeye erişimin yok." } });
        }

        return Ok(result);
    }

    [HttpGet("task/{taskItemId}")]
    public async Task<ActionResult<List<TaskAttachmentResponseDto>>> GetAttachments(int taskItemId)
    {
        var currentUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (currentUserId == null)
            return Unauthorized();

        var result = await _attachmentService.GetAttachmentsAsync(taskItemId, currentUserId);

        return Ok(result);
    }

    [HttpGet("download/{id}")]
    public async Task<IActionResult> DownloadFile(int id)
    {
        var currentUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (currentUserId == null)
            return Unauthorized();

        var attachment = await _attachmentService.GetAttachmentByIdAsync(id, currentUserId);

        if (attachment == null)
            return NotFound(new ApiErrorResponse { Title = "Bulunamadı", StatusCode = 404, Errors = new List<string> { "Dosya bulunamadı." } });

        if (!System.IO.File.Exists(attachment.FilePath))
            return NotFound(new ApiErrorResponse { Title = "Bulunamadı", StatusCode = 404, Errors = new List<string> { "Dosya sistemde bulunamadı." } });

        var stream = new FileStream(attachment.FilePath, FileMode.Open, FileAccess.Read);

        return File(stream, attachment.ContentType, attachment.OriginalFileName);
    }
}