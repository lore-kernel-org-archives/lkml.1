Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbYD3INH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbYD3INH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 04:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbYD3IMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 04:12:48 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58543 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754953AbYD3IMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 04:12:47 -0400
From: Paul Jackson <pj@sgi.com>
To: akpm@linux-foundation.org
Cc: Simon Derr <simon.derr@bull.net>, Paul Menage <menage@google.com>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Date: Wed, 30 Apr 2008 01:12:44 -0700
Message-Id: <20080430081244.187543.95612.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH] cpusets: update maintainers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Update CPUSETS MAINTAINERS to reflect the more active
role of Paul Menage (secondary to his work on cgroups)
and the retirement of the original author of cpusets,
Simon Derr.  Thanks, Simon!  Best of luck to you.

Signed-off-by: Paul Jackson <pj@sgi.com>
Acked-by: Paul Menage <menage@google.com>
Acked-by: Simon Derr <simon.derr@bull.net>

---
 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- 2.6.25-mm1-mmotm.orig/MAINTAINERS	2008-04-30 00:56:27.000000000 -0700
+++ 2.6.25-mm1-mmotm/MAINTAINERS	2008-04-30 01:05:09.425822939 -0700
@@ -1199,9 +1199,9 @@ S:	Maintained
 
 CPUSETS
 P:	Paul Jackson
-P:	Simon Derr
+P:	Paul Menage
 M:	pj@sgi.com
-M:	simon.derr@bull.net
+M:	menage@google.com
 L:	linux-kernel@vger.kernel.org
 W:	http://www.bullopensource.org/cpuset/
 S:	Supported

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
