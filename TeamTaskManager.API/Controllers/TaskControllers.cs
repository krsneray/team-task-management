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
public class TaskController : ControllerBase
{
    private readonly TaskService _taskService;

    public TaskController(TaskService taskService)
    {
        _taskService = taskService;
    }

    [HttpPost]
    [Authorize(Roles = "Admin,ProjectManager")]
    public async Task<ActionResult<TaskResponseDto>> CreateTask(
        CreateTaskDto dto)
    {
        var createdByUserId = User.FindFirstValue(
            ClaimTypes.NameIdentifier);

        if (createdByUserId == null)
            return Unauthorized();

        var result = await _taskService.CreateTaskAsync(
            dto,
            createdByUserId);

        if (result == null)
            return BadRequest(new ApiErrorResponse
            {
                Title = "Hata",
                StatusCode = 400,
                Errors = new List<string> { "Proje ya da atanan kullanıcı bulunamadı." }
            });

        return Ok(result);
    }

    [HttpGet]
    public async Task<ActionResult<List<TaskResponseDto>>> GetTasks()
    {
        var currentUserId = User.FindFirstValue(
            ClaimTypes.NameIdentifier);

        if (currentUserId == null)
            return Unauthorized();

        var result = await _taskService.GetTasksAsync(
            currentUserId);

        return Ok(result);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<TaskResponseDto>> GetTask(int id)
    {
        var currentUserId = User.FindFirstValue(
            ClaimTypes.NameIdentifier);

        if (currentUserId == null)
            return Unauthorized();

        var result = await _taskService.GetTaskByIdAsync(
            id,
            currentUserId);

        if (result == null)
            return NotFound();

        return Ok(result);
    }

    [HttpPut("{id}")]
    [Authorize(Roles = "Admin,ProjectManager")]
    public async Task<ActionResult<TaskResponseDto>> UpdateTask(
        int id,
        UpdateTaskDto dto)
    {
        var currentUserId = User.FindFirstValue(
            ClaimTypes.NameIdentifier);

        if (currentUserId == null)
            return Unauthorized();

        if (!await _taskService.UserExistsAsync(dto.AssignedUserId))
            return BadRequest(new ApiErrorResponse
            {
                Title = "Hata",
                StatusCode = 400,
                Errors = new List<string> { "Atanan kullanıcı bulunamadı." }
            });

        var result = await _taskService.UpdateTaskAsync(
            id,
            dto,
            currentUserId);

        if (result == null)
            return NotFound();

        return Ok(result);
    }

    [HttpPatch("{id}/status")]
    public async Task<ActionResult<TaskResponseDto>> UpdateTaskStatus(
        int id,
        UpdateTaskStatusDto dto)
    {
        var currentUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (currentUserId == null)
            return Unauthorized();

        try
        {
            var result = await _taskService.UpdateTaskStatusAsync(
                id,
                dto.Status,
                currentUserId);

            if (result == null)
                return NotFound(new ApiErrorResponse { Title = "Bulunamadı", StatusCode = 404, Errors = new List<string> { "Görev bulunamadı." } });

            return Ok(result);
        }
        catch (UnauthorizedAccessException ex)
        {
            return StatusCode(StatusCodes.Status403Forbidden, new ApiErrorResponse
            {
                Title = "Yetki Hatası",
                StatusCode = 403,
                Errors = new List<string> { ex.Message }
            });
        }
    }

    [HttpDelete("{id}")]
    [Authorize(Roles = "Admin,ProjectManager")]
    public async Task<IActionResult> DeleteTask(int id)
    {
        var currentUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (currentUserId == null)
            return Unauthorized();

        var result = await _taskService.DeleteTaskAsync(id, currentUserId);

        if (!result)
            return NotFound(new ApiErrorResponse { Title = "Bulunamadı", StatusCode = 404, Errors = new List<string> { "Görev bulunamadı." } });

        return NoContent();
    }
}