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
        var initialPassword = configuration["InitialAdmin:Password"];

        // E-posta ya da parola ayarlanmamışsa ilk yönetici oluşturulmaz.
        if (string.IsNullOrWhiteSpace(adminMail) || string.IsNullOrWhiteSpace(initialPassword))
        {
            return;
        }

        var existingAdmin = await userManager.FindByEmailAsync(adminMail);

        if (existingAdmin != null)
        {
            if (!await userManager.IsInRoleAsync(existingAdmin, "Admin"))
            {
                await userManager.AddToRoleAsync(existingAdmin, "Admin");
            }

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

        var result = await userManager.CreateAsync(adminUser, initialPassword);

        if (result.Succeeded)
        {
            await userManager.AddToRoleAsync(adminUser, "Admin");
        }
    }
}
