using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using TeamTaskManager.Entities;

namespace TeamTaskManager.API;

public static class DbSeeder
{
    public static async Task SeedRolesAsync(RoleManager<IdentityRole> roleManager)
    {
        string[] roles = { "Admin", "ProjectManager", "TeamMember"};

        foreach (var role in roles)
        {
            var exists = await roleManager.RoleExistsAsync(role);
            if(!exists)
            {
                await roleManager.CreateAsync(new IdentityRole(role));
            }
        }
    }

    public static async Task SeedAdminUserAsync(UserManager<ApplicationUser> userManager, IConfiguration configuration)
    {
        var adminMail = configuration["InitialAdmin:Email"];
        var existingAdmin = await userManager.FindByEmailAsync(adminMail);

        if(existingAdmin != null)
        {
            return;
        }

        var adminUser = new ApplicationUser
        {
            FirstName = configuration["InitialAdmin:FirstName"]!,
            LastName = configuration["InitialAdmin:LastName"]!,
            Email = adminMail,
            UserName = adminMail,
            EmailConfirmed = true
        };

        var password = configuration["InitialAdmin:Password"]!;
        var result = await userManager.CreateAsync(adminUser, password);

        if (result.Succeeded)
        {
            await userManager.AddToRoleAsync(adminUser, "Admin");
        }
    }
}
