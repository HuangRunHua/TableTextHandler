# Before Starting with TableTextHandler

Preparations required before using this framework.

## Overview

TableTextHandler is a framework for **Command Line Tool** under Xcode macOS selection. Before processing text files, you need to create a Command Line Tool program. Every Command Line Tools program needs to add a **Bundle** file (file with extension ".bundle") so that Xcode can understand where the target files (text files) store.

### Create a Command Line Tool Program

To create a Command Line Tools program, you first open Xcode and create a new project, select the **macOS option** in the pop-up interface and pick **Command Line Tool**, then tap **Next**, enter the project name you want and select where the project stores.
![](2.png)

### Add a Bundle File
Normally, Xcode cannot directly read externally added documentation files in Command Line Tool. However, it is possible to read external documents by adding a custom bundle.

In Xcode, select **File -> New -> Target**, select **Bundle** in Target, and customize the name of the bundle, such as `DataBundle`.
![](3.png)

Drag your text file to the project, and select **Target Membership** with this bundle, then make sure the bundle is ticked in its target membership section:
![](4.png)

Finally add the bundle to your target. In the target's build phase, open the **copy files** phase and click the **+** button. Select the bundle and click **Add**, result shows in the following picture:
![](5.png)

### Add TableTextHandler Package as Frameworks and Libraries
After fetching `TableTextHandler` package using Swift Package, you need to confirm that both Tagets (project target and bundle target) have embed TableTextHandler Package.
The following picture shows a project with `TableTextHandler` package that has been successfully added to Frameworks and Libraries. 
![The Project Target](6.png)
The following picture shows a bundle with `TableTextHandler` package that has been successfully added to Frameworks and Libraries. 
![](7.png)

