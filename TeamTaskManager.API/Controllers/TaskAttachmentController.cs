using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using TeamTaskManager.Business;
using TeamTaskManager.DTO;

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

    // 1- Göreve dosya yükleme
    [HttpPost("upload/{taskItemId}")]
    [Consumes("multipart/form-data")]
    public async Task<ActionResult<TaskAttachmentResponseDto>> UploadFile(
        int taskItemId,
        IFormFile file)
    {
        var currentUserId = User.FindFirstValue(
            ClaimTypes.NameIdentifier);

        if (currentUserId == null)
            return Unauthorized();

        if (file == null || file.Length == 0)
            return BadRequest("Dosya seçilmedi.");

        // Uploads klasörü yoksa oluşturuyoruz
        var uploadsFolder = Path.Combine(
            _environment.ContentRootPath,
            "Uploads");

        if (!Directory.Exists(uploadsFolder))
        {
            Directory.CreateDirectory(uploadsFolder);
        }

        // Dosyanın uzantısını alıyoruz
        var extension = Path.GetExtension(file.FileName);

        // Aynı isimli dosyalar karışmasın diye farklı isim veriyoruz
        var storedFileName =
            Guid.NewGuid().ToString() + extension;

        var filePath = Path.Combine(
            uploadsFolder,
            storedFileName);

        // Dosyayı klasöre kaydediyoruz
        using (var stream = new FileStream(
            filePath,
            FileMode.Create))
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
            // Kayıt eklenmediyse dosyayı siliyoruz
            if (System.IO.File.Exists(filePath))
            {
                System.IO.File.Delete(filePath);
            }

            return BadRequest(
                "Görev bulunamadı veya bu projeye erişimin yok.");
        }

        return Ok(result);
    }

    // 2- Göreve ait dosyaları listeleme
    [HttpGet("task/{taskItemId}")]
    public async Task<ActionResult<List<TaskAttachmentResponseDto>>>
        GetAttachments(int taskItemId)
    {
        var currentUserId = User.FindFirstValue(
            ClaimTypes.NameIdentifier);

        if (currentUserId == null)
            return Unauthorized();

        var result =
            await _attachmentService.GetAttachmentsAsync(
                taskItemId,
                currentUserId);

        return Ok(result);
    }

    // 3- Dosya indirme
    [HttpGet("download/{id}")]
    public async Task<IActionResult> DownloadFile(int id)
    {
        var currentUserId = User.FindFirstValue(
            ClaimTypes.NameIdentifier);

        if (currentUserId == null)
            return Unauthorized();

        var attachment =
            await _attachmentService.GetAttachmentByIdAsync(
                id,
                currentUserId);

        if (attachment == null)
            return NotFound("Dosya bulunamadı.");

        if (!System.IO.File.Exists(attachment.FilePath))
            return NotFound("Dosya sistemde bulunamadı.");

        var fileBytes =
            await System.IO.File.ReadAllBytesAsync(
                attachment.FilePath);

        return File(
            fileBytes,
            attachment.ContentType,
            attachment.OriginalFileName);
    }
}