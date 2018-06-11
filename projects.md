---
title: Projects
layout: default
use_fontawesome: true
---

<!-- Research -->
<h1 class="section-title">Research</h1>

<div class="row content-row">
<div class="col-12 col-sm-4 image-wrapper">
    <img src="{{ site.baseurl }}/images/research_poverty_ermon.jpg">
</div>
<div class="col-12 col-sm-8">
    <h3>Poverty Prediction with Public Landsat 7 Satellite Imagery and Machine Learning</h3>
    <p class="italic">Summer 2017 - Present</p>
    <p><span class="bold">Abstract:</span> Obtaining detailed and reliable data about local economic livelihoods in developing countries is expensive, and data are consequently scarce. Previous work has shown that it is possible to measure local-level economic livelihoods using high-resolution satellite imagery. However, such imagery is relatively expensive to acquire, often not updated frequently, and is mainly available for recent years. We train CNN models on free and publicly available multispectral daytime satellite images of the African continent from the Landsat 7 satellite, which has collected imagery with global coverage for almost two decades. We show that despite these images' lower resolution, we can achieve accuracies that exceed previous benchmarks.</p>
    <p><span class="bold">Mentors:</span> Stefano Ermon, Marshall Burke, David Lobell</p>
    <p><span class="bold">Conference Workshop Paper:</span> NIPS Conference 2017, Workshop on Machine Learning for the Developing World</p>
    <a href="https://arxiv.org/pdf/1711.03654.pdf" class="btn btn-light">
        <i class="fa fa-file"></i> Paper
    </a>
</div>
</div>
<hr>

<div class="row content-row">
<div class="col-12 col-sm-4 image-wrapper">
    <img src="{{ site.baseurl }}/images/research_stereo_ihler.png">
</div>
<div class="col-12 col-sm-8">
    <h3>Conditional Random Fields for Dense Stereo Matching</h3>
    <p class="italic">Summer 2012 - Summer 2014</p>
    <p><span class="bold">Abstract:</span> Various algorithms have been developed over the past two decades for solving the stereo correspondence problem, which is defined as the identification of the offset or disparity of an object in a pair of stereo images. Recent work has shown that conditional random fields (CRFs) have the potential to be faster and more accurate than traditional local matching algorithms. The canonical CRF for solving dense stereo matching problems uses a basic energy function that accounts for both local intensity matching and smoothness costs. Traditionally, the smoothness term relies on a binary Potts Model which fails to assign different costs to different disparities. In this paper, we extend the smoothness term in the energy function to be more robust. Specifically, we explore using a logarithmic function modulated by discrete edge gradient bins and binary edge detection features. The logarithmic function is able to distinguish between different disparities and therefore assign more appropriate costs. Our results suggest that our algorithm exceeds the performance of the traditional smoothness term based on a Potts Model. However, further optimization in our CRF evaluation process is necessary to achieve real-time outputs.</p>
    <p><span class="bold">Mentor:</span> Dr. Alex Ihler, UC Irvine</p>
    <p><span class="bold">Presentation:</span> 2013 Southern California Conference for Undergraduate Research (SCCUR) at Whittier College, CA</p>
    <a href="https://drive.google.com/file/d/0B-7rmGyO0CsvVC1aVVlPUzEtTkE/view" class="btn btn-light">
        <i class="fa fa-file"></i> Presentation Slides
    </a>
    <a href="https://youtu.be/Q3Iml7WxyKw" class="btn btn-light">
        <i class="fab fa-youtube"></i> Presentation Video
    </a>
</div>
</div>
<hr>

<div class="row content-row">
<div class="col-12 col-sm-4">
    <img src="{{ site.baseurl }}/images/research_foam_tanner.jpg">
</div>
<div class="col-12 col-sm-8 section">
    <h3>Effect of Aging on the Foam Fractionation of Lactoferrin</h3>
    <p class="italic">Summer 2011</p>
    <p><span class="bold">Abstract:</span> Foam fractionation is an inexpensive and simple technique for concentrating proteins. The foamability of a protein can drastically change with the age of the protein. The foamability of solutions created from ten year old bovine lactoferrin (bLF) protein was investigated with varying concentration protein, air flow velocity, and the pH of the solution. The results suggest the foamability of the aged protein decreased to an insignificant level except at high pH with a protein concentration of 0.1 mg/mL.</p>
    <p><span class="bold">Mentor:</span> Dr. Robert Tanner, Caltech</p>
    <p><span class="bold">Collaborators:</span> Benjamin Yeh, Yuehan Huang</p>
    <p><span class="bold">Presentation:</span> 43rd American Chemistry Society Western Regional Meeting, Pasadena, CA</p>
</div>
</div>

<!-- Experience -->
<h1 class="section-title">Experience</h1>

<div class="row content-row">
<div class="col-12 col-sm-4">
    <img src="images/apple_ios.png">
</div>
<div class="col-12 col-sm-8">
    <h3>Apple Software Engineer Intern</h3>
    <p class="italic">June 2016 - September 2016</p>
    <p>I interned on the iOS SpringBoard team, improving the system app for iOS 10 and future releases. Project details under NDA.</p>
</div>
</div>
<hr>

<div class="row content-row">
<div class="col-12 col-sm-4">
    <img src="{{ site.baseurl }}/images/qb_ios.png">
</div>
<div class="col-12 col-sm-8">
    <h3>Intuit Software Engineer Intern</h3>
    <p class="italic">June 2015 - August 2015</p>
    <p>As an intern on the Intuit QuickBooks Mobile iOS team, I taught myself Objective-C, Swift 2, and SQL on the job. I helped pioneer my team's transition from Objective-C to Swift and the adoption of Apple's latest guidelines for universal iOS apps to accommodate multitasking in iOS 9. I also added employee time-tracking and time-sheets features to the iOS app. My work involved full stack development from database management and memory-efficiency optimizations to adaptive UI design and animations.</p>
</div>
</div>
<hr>

<!-- Projects -->
<h1 class="section-title">Projects</h1>

<div class="row content-row">
<div class="col-12 col-sm-4">
    <img src="{{ site.baseurl }}/images/ctc.png">
</div>
<div class="col-12 col-sm-8">
    <h3>Photo Licensing Platform</h3>
    <p class="italic">September 2015 - present</p>
    <p>Currently, there is no centralized platform for media consumers to easily purhcase licenses from photographers and graphic designers. Through Stanford Code the Change, I am leading a team to create a prototype web application that simplifies the process of creating and purchasing licenses for copyrighted photos and images. This proof-of-concept app was built in collaboration with the U.S. Copyright Office and the Stanford Law School. For this project, I used Python, Flask, and SQL, and then deployed the app to Heroku.</p>
    <a href="https://copyright-license.herokuapp.com/" class="btn btn-light">
        <i class="fas fa-external-link-square-alt"></i> Demo
    </a>
    <a href="https://github.com/chrisyeh96/copyright-license" class="btn btn-light">
        <i class="fab fa-github"></i> GitHub
    </a>
</div>
</div>
<hr>

<div class="row content-row">
<div class="col-12 col-sm-4">
    <img src="{{ site.baseurl }}/images/moodmusic.png">
</div>
<div class="col-12 col-sm-8">
    <h3>Mood Music Firefox Add-on</h3>
    <p class="italic">May 2014</p>
    <p class="note">
        <i class="fa fa-star"></i>
        HackUCI Hackathon, Top 10 Hacks and Best Rdio Hack
    </p>
    <p>Mood Music is a Firefox add-on that provides users with content-relevant music that reflects the mood of the websites they visit. It uses a combination of text-extraction through Diffbot, natural language processing of mood, and integration with the Rdio API to create this Firefox add-on. The inspiration behind this lies in alleviating the burden of finding good music during a user’s browsing experience.</p>
    <a href="https://github.com/skswbwt/bgradio" class="btn btn-light">
        <i class="fab fa-github"></i> GitHub
    </a>
    <a href="https://devpost.com/software/mood-music" class="btn btn-light">
        <i class="fa fa-info-circle"></i> Project Profile
    </a>
    <a href="https://youtu.be/oYl99kzciQA" class="btn btn-light">
        <i class="fab fa-youtube"></i> Presentation Video
    </a>
</div>
</div>
