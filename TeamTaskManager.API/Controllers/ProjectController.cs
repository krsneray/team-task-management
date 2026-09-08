using System.Security.Claims;
using TeamTaskManager.DTO;
using TeamTaskManager.DTO.Common; 
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

    [Authorize]
    [HttpGet]
    public async Task<ActionResult<List<ProjectResponseDto>>> GetProjects()
    {
        var result = await _projectService.GetProjectsAsync();

        return Ok(result);
    }

    [Authorize]
    [HttpGet("{id}")]
    public async Task<ActionResult<ProjectResponseDto>> GetProjectById(int id)
    {
        var result = await _projectService.GetProjectByIdAsync(id);

        if (result == null)
            return NotFound(new ApiErrorResponse { Title = "Bulunamadı", StatusCode = 404, Errors = new List<string> { "Proje bulunamadı." } }); 

        return Ok(result);
    }

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
                return NotFound(new ApiErrorResponse { Title = "Bulunamadı", StatusCode = 404, Errors = new List<string> { "Proje bulunamadı." } }); 

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
                return NotFound(new ApiErrorResponse { Title = "Bulunamadı", StatusCode = 404, Errors = new List<string> { "Proje bulunamadı." } }); 

            return NoContent();
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
}