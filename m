Return-Path: <linux-kernel-owner+w=401wt.eu-S1759290AbZDRAd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290AbZDRAd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 20:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbZDRAdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 20:33:51 -0400
Received: from waste.org ([66.93.16.53]:49110 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbZDRAdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 20:33:51 -0400
Subject: [PATCH] add myself as HW RNG maintainer
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 19:32:34 -0500
Message-Id: <1240014754.3307.503.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r 8e0f1cee0a71 MAINTAINERS
--- a/MAINTAINERS	Sat Jan 24 15:41:13 2009 -0600
+++ b/MAINTAINERS	Fri Apr 17 19:30:14 2009 -0500
@@ -1917,7 +1917,10 @@
 S:	Orphan
 
 HARDWARE RANDOM NUMBER GENERATOR CORE
-S:	Orphan
+P:	Matt Mackall
+M:	mpm@selenic.com
+S:	Maintained
+F:	drivers/char/hw_random/
 
 HARMONY SOUND DRIVER
 P:	Kyle McMartin
@@ -3538,6 +3541,7 @@
 P:	Matt Mackall
 M:	mpm@selenic.com
 S:	Maintained
+F:	drivers/char/random.c
 
 RAPIDIO SUBSYSTEM
 P:	Matt Porter

-- 
http://selenic.com : development and support for Mercurial and Linux


