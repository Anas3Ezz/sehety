plugins {
    id("com.google.gms.google-services") version "4.4.4" apply false
}

// 2. Repository configuration for all modules
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// 3. Your custom build directory logic
val newBuildDir: Directory = rootProject.layout.buildDirectory
    .dir("../../build")
    .get()

rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// 4. The clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}