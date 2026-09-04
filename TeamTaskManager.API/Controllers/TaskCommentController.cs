using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using TeamTaskManager.Business;
using TeamTaskManager.DTO;

namespace TeamTaskManager.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class TaskCommentController : ControllerBase
{
    private readonly TaskCommentService _taskCommentService;

    public TaskCommentController(TaskCommentService taskCommentService)
    {
        _taskCommentService = taskCommentService;
    }

    // Göreve yorum ekleme
    [HttpPost]
    public async Task<ActionResult<TaskCommentResponseDto>> CreateComment(
        CreateTaskCommentDto dto)
    {
        // Giriş yapan kullanıcının id'sini alıyoruz
        var currentUserId = User.FindFirstValue(
            ClaimTypes.NameIdentifier);

        if (currentUserId == null)
            return Unauthorized();

        // Yorumu ekliyoruz
        var result = await _taskCommentService.CreateCommentAsync(
            dto,
            currentUserId);

        // Görev bulunamazsa
        if (result == null)
            return NotFound();

        return Ok(result);
    }

    // Bir göreve ait yorumları listeleme
    [HttpGet("task/{taskItemId}")]
    public async Task<ActionResult<List<TaskCommentResponseDto>>> GetComments(
        int taskItemId)
    {
        // Giriş yapan kullanıcının id'sini alıyoruz
        var currentUserId = User.FindFirstValue(
            ClaimTypes.NameIdentifier);

        if (currentUserId == null)
            return Unauthorized();

        // Görevin yorumlarını getiriyoruz
        var result = await _taskCommentService.GetCommentsByTaskIdAsync(
            taskItemId,
            currentUserId);

        return Ok(result);
    }
}