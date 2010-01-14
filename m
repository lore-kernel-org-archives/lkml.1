Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879Ab0ANSU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab0ANSU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 13:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495Ab0ANSU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 13:20:58 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:36606 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab0ANSU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 13:20:58 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 14 Jan 2010 19:20:47 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] HOWTO: Point to patchwork.kernel.org and patchwork.ozlabs.org
To: linux-kernel@vger.kernel.org
cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>
In-Reply-To: <4B4F5CC8.7020107@s5r6.in-berlin.de>
Message-ID: <tkrat.b7babd2a0d4d4539@s5r6.in-berlin.de>
References: <cover.1263452908.git.joe@perches.com> 
 <dad0b9fe4d42d6523c16edfc5275a01de1272fd4.1263452908.git.joe@perches.com> 
 <4B4F20B3.703@s5r6.in-berlin.de>  <4B4F2402.9040008@s5r6.in-berlin.de>
 <1263490722.1903.12.camel@Joe-Laptop.home>
 <4B4F5CC8.7020107@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/* does not mention patchwork yet although quite a
number of subsystem development lists is watched by patchwork now.
Submitters and testers may find these sites useful.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 Documentation/HOWTO |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index 8495fc9..82e3a3b 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -372,6 +372,13 @@ Here is a list of some of the different kernel trees available:
   Other kernel trees can be found listed at http://git.kernel.org/ and in
   the MAINTAINERS file.
 
+Several subsystem maintainers use a web-based patch management system to
+keep track of patch submissions.  Submitters and other developers can use
+these patch trackers too to check what progress a patch is making on its
+way into subsystem repositories:
+   http://patchwork.kernel.org/
+   http://patchwork.ozlabs.org/
+
 Bug Reporting
 -------------
 
-- 
1.6.4.4


-- 
Stefan Richter
-=====-==-=- ---= -===-
http://arcgraph.de/sr/

