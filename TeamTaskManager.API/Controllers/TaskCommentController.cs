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

    [HttpPost]
    public async Task<ActionResult<TaskCommentResponseDto>> CreateComment(
        CreateTaskCommentDto dto)
    {
        var currentUserId = User.FindFirstValue(
            ClaimTypes.NameIdentifier);

        if (currentUserId == null)
            return Unauthorized();

        var result = await _taskCommentService.CreateCommentAsync(
            dto,
            currentUserId);

        if (result == null)
            return NotFound();

        return Ok(result);
    }

    [HttpGet("task/{taskItemId}")]
    public async Task<ActionResult<List<TaskCommentResponseDto>>> GetComments(
        int taskItemId)
    {
        var currentUserId = User.FindFirstValue(
            ClaimTypes.NameIdentifier);

        if (currentUserId == null)
            return Unauthorized();

        var result = await _taskCommentService.GetCommentsByTaskIdAsync(
            taskItemId,
            currentUserId);

        return Ok(result);
    }
}