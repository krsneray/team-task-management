using System.Security.Claims;
using TeamTaskManager.DTO;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TeamTaskManager.Business;

namespace TeamTaskManager.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ProjectController : ControllerBase
{
    private readonly ProjectService _projectService;

    public ProjectController(ProjectService projectService)
    {
        _projectService = projectService;
    }

    // POST: api/Project
    [Authorize(Roles = "Admin,ProjectManager")]
    [HttpPost]
    public async Task<ActionResult<ProjectResponseDto>> CreateProject(
        CreateProjectDto dto)
    {
        var managerUserId = User.FindFirstValue(
            ClaimTypes.NameIdentifier);

        if (managerUserId == null)
            return Unauthorized();

        var result = await _projectService.CreateProjectAsync(
            dto,
            managerUserId);

        return Ok(result);
    }

    // GET: api/Project
    [Authorize]
    [HttpGet]
    public async Task<ActionResult<List<ProjectResponseDto>>> GetProjects()
    {
        var result = await _projectService.GetProjectsAsync();

        return Ok(result);
    }

    // GET: api/Project/{id}
    [Authorize]
    [HttpGet("{id}")]
    public async Task<ActionResult<ProjectResponseDto>> GetProjectById(int id)
    {
        var result = await _projectService.GetProjectByIdAsync(id);

        if (result == null)
            return NotFound();

        return Ok(result);
    }

    // PUT: api/Project/{id}
    [Authorize(Roles = "Admin,ProjectManager")]
    [HttpPut("{id}")]
    public async Task<ActionResult<ProjectResponseDto>> UpdateProject(
        int id,
        UpdateProjectDto dto)
    {
        var currentUserId = User.FindFirstValue(
            ClaimTypes.NameIdentifier);

        if (currentUserId == null)
            return Unauthorized();

        try
        {
            var result = await _projectService.UpdateProjectAsync(
                id,
                dto,
                currentUserId);

            if (result == null)
                return NotFound();

            return Ok(result);
        }
        catch (UnauthorizedAccessException ex)
        {
            return Forbid(ex.Message);
        }
    }

    // DELETE: api/Project/{id}
    [Authorize(Roles = "Admin,ProjectManager")]
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteProject(int id)
    {
        var currentUserId = User.FindFirstValue(
            ClaimTypes.NameIdentifier);

        if (currentUserId == null)
            return Unauthorized();

        try
        {
            var result = await _projectService.DeleteProjectAsync(
                id,
                currentUserId);

            if (!result)
                return NotFound();

            return NoContent();
        }
        catch (UnauthorizedAccessException ex)
        {
            return Forbid(ex.Message);
        }
    }
}