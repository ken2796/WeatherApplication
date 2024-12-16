Committing the Project to GitHub

1. Create a GitHub Repository
Go to GitHub and log in to your account.
Click on the New button to create a new repository.
Provide a repository name, description (optional), and choose its visibility (Public/Private).
Click Create Repository.

2. Initialize Git in Your Project
Open a terminal in your project's root directory and run:
 
-> git init

3. Add Files to Staging
Add your project files to the staging area:

-> git add .

4. Commit Your Changes
Commit the changes with a descriptive message:
 
-> git commit -m "Initial commit"

5. Link Your Local Repository to GitHub
Copy the repository URL from GitHub (SSH or HTTPS). Then run:
 
-> git remote add origin <repository_url>

6. Push Your Code to GitHub
Push your code to the GitHub repository's main branch:
 
-> git branch -M main
 
-> git push -u origin main

7. Verify on GitHub
Go back to your GitHub repository page. Your code should now appear there.


You will find my weather application there. Open the file and click on the blue file named "WeatherApplication.swift". Take note: you can open it in Visual Studio, but you won't be able to run it. You need to download Xcode. Once downloaded, click the WeatherApplication file, then click View, and you'll see the preview of the app I created. To run it on the simulator, first check which device you want to use, then build the project.




