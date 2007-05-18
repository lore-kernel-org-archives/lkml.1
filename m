Return-Path: <linux-kernel-owner+w=401wt.eu-S1758216AbXEROsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216AbXEROsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 10:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbXEROsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 10:48:00 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:54024 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbXEROsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 10:48:00 -0400
X-Greylist: delayed 2109 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 May 2007 10:48:00 EDT
Message-ID: <464DB45C.8070200@mentorg.com>
Date: Fri, 18 May 2007 19:42:44 +0530
From: Pranith Kumar D <pranith-kumar_d@mentor.com>
User-Agent: Thunderbird 1.5 (X11/20051201)
MIME-Version: 1.0
To: greg@kroah.com, penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
       debiandev@gmail.com
Subject: [PATCH 1/1] FIX HOWTO: removing duplicated entry.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 May 2007 14:12:44.0622 (UTC) FILETIME=[9AC57EE0:01C79956]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
    Sorry for submitting the previous patch without description, name 
signed off line.

This removes the duplicated paragraph in the Documentation/HOWTO file.

Signed-off-by: D Pranith Kumar<pranith-kumar_d@mentorg.com>

--- linux-2.6.21.1/Documentation/HOWTO.orig	2007-05-18 18:54:18.000000000 +0530
+++ linux-2.6.21.1/Documentation/HOWTO	2007-05-18 18:55:03.000000000 +0530
@@ -383,26 +383,6 @@ One of the best ways to put into practic
 bugs reported by other people. Not only you will help to make the kernel
 more stable, you'll learn to fix real world problems and you will improve
 your skills, and other developers will be aware of your presence. Fixing
-bugs is one of the best ways to earn merit amongst the developers, because
-not many people like wasting time fixing other people's bugs.
-
-To work in the already reported bug reports, go to http://bugzilla.kernel.org.
-If you want to be advised of the future bug reports, you can subscribe to the
-bugme-new mailing list (only new bug reports are mailed here) or to the
-bugme-janitor mailing list (every change in the bugzilla is mailed here)
-
-	http://lists.osdl.org/mailman/listinfo/bugme-new
-	http://lists.osdl.org/mailman/listinfo/bugme-janitors
-
-
-
-Managing bug reports
---------------------
-
-One of the best ways to put into practice your hacking skills is by fixing
-bugs reported by other people. Not only you will help to make the kernel
-more stable, you'll learn to fix real world problems and you will improve
-your skills, and other developers will be aware of your presence. Fixing
 bugs is one of the best ways to get merits among other developers, because
 not many people like wasting time fixing other people's bugs.
 



