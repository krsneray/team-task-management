using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using TeamTaskManager.Business;
using TeamTaskManager.DTO;

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

    // POST: api/Task
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

        return Ok(result);
    }

    // GET: api/Task
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

    // GET: api/Task/{id}
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

    // PUT: api/Task/{id}
    [HttpPut("{id}")]
    [Authorize(Roles = "Admin,ProjectManager")]
    public async Task<ActionResult<TaskResponseDto>> UpdateTask(
        int id,
        UpdateTaskDto dto)
    {
        var result = await _taskService.UpdateTaskAsync(
            id,
            dto);

        if (result == null)
            return NotFound();

        return Ok(result);
    }

    // DELETE: api/Task/{id}
    [HttpDelete("{id}")]
    [Authorize(Roles = "Admin,ProjectManager")]
    public async Task<IActionResult> DeleteTask(int id)
    {
        var result = await _taskService.DeleteTaskAsync(id);

        if (!result)
            return NotFound();

        return NoContent();
    }
}