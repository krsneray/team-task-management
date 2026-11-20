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

    [Authorize]
    [HttpGet("{id}/members")]
    public async Task<ActionResult<List<ProjectMemberResponseDto>>> GetMembers(int id)
    {
        var result = await _projectService.GetMembersAsync(id);

        if (result == null)
            return NotFound(new ApiErrorResponse { Title = "Bulunamadı", StatusCode = 404, Errors = new List<string> { "Proje bulunamadı." } });

        return Ok(result);
    }

    [Authorize(Roles = "Admin,ProjectManager")]
    [HttpPost("{id}/members")]
    public async Task<IActionResult> AddMember(int id, AddProjectMemberDto dto)
    {
        var currentUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (currentUserId == null)
            return Unauthorized();

        try
        {
            var result = await _projectService.AddMemberAsync(id, dto.UserId, currentUserId);

            return result switch
            {
                AddMemberResult.Added => NoContent(),
                AddMemberResult.ProjectNotFound => NotFound(new ApiErrorResponse { Title = "Bulunamadı", StatusCode = 404, Errors = new List<string> { "Proje bulunamadı." } }),
                AddMemberResult.UserNotFound => BadRequest(new ApiErrorResponse { Title = "Hata", StatusCode = 400, Errors = new List<string> { "Kullanıcı bulunamadı ya da pasif." } }),
                _ => BadRequest(new ApiErrorResponse { Title = "Hata", StatusCode = 400, Errors = new List<string> { "Kullanıcı zaten projenin üyesi." } })
            };
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
    [HttpDelete("{id}/members/{userId}")]
    public async Task<IActionResult> RemoveMember(int id, string userId)
    {
        var currentUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (currentUserId == null)
            return Unauthorized();

        try
        {
            var result = await _projectService.RemoveMemberAsync(id, userId, currentUserId);

            if (!result)
                return NotFound(new ApiErrorResponse { Title = "Bulunamadı", StatusCode = 404, Errors = new List<string> { "Proje ya da üye bulunamadı." } });

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
        catch (InvalidOperationException ex)
        {
            return BadRequest(new ApiErrorResponse
            {
                Title = "Hata",
                StatusCode = 400,
                Errors = new List<string> { ex.Message }
            });
        }
    }
}