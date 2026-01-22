allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
//deplacement vers build
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)
// si  : app est evalue en premier
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}
//tâche pour nettoyer
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
