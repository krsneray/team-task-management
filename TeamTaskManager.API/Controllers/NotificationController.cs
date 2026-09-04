using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using TeamTaskManager.Business;
using TeamTaskManager.DTO;

namespace TeamTaskManager.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class NotificationController : ControllerBase
{
    private readonly NotificationService _notificationService;

    public NotificationController(NotificationService notificationService)
    {
        _notificationService = notificationService;
    }


    // 1- Kullanıcının bildirimlerini getirme
    [HttpGet]
    public async Task<ActionResult<List<NotificationResponseDto>>>
        GetNotifications()
    {
        var currentUserId = User.FindFirstValue(
            ClaimTypes.NameIdentifier);

        if (currentUserId == null)
            return Unauthorized();

        var result = await _notificationService
            .GetNotificationsAsync(currentUserId);

        return Ok(result);
    }


    // 2- Bildirimi okundu yapma
    [HttpPut("{id}/read")]
    public async Task<IActionResult> MarkAsRead(int id)
    {
        var currentUserId = User.FindFirstValue(
            ClaimTypes.NameIdentifier);

        if (currentUserId == null)
            return Unauthorized();

        var result = await _notificationService
            .MarkAsReadAsync(id, currentUserId);

        if (!result)
            return NotFound("Bildirim bulunamadı.");

        return Ok("Bildirim okundu olarak işaretlendi.");
    }
}