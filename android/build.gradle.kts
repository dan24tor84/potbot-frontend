// Top-level Gradle build file

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Keep the app module evaluated before others that depend on it
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}