Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbYFIVof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbYFIVof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 17:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758618AbYFIVoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 17:44:22 -0400
Received: from relay1.sgi.com ([192.48.171.29]:33740 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758539AbYFIVoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 17:44:22 -0400
From: Paul Jackson <pj@sgi.com>
To: akpm@linux-foundation.org
Cc: Simon Derr <simon.derr@bull.net>, Paul Menage <menage@google.com>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Date: Mon, 09 Jun 2008 14:44:19 -0700
Message-Id: <20080609214419.260968.50473.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH] cpusets: provide another web page URL in MAINTAINERS file
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Add URL for another CPUSETS web page to the MAINTAINERS file.

This URL provides links to major LGPL user level C libraries supporting
cpuset usage and user level cpu and node masks.

Signed-off-by: Paul Jackson <pj@sgi.com>

---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- 2.6.26-rc5-mm1.orig/MAINTAINERS	2008-06-09 14:31:06.000000000 -0700
+++ 2.6.26-rc5-mm1/MAINTAINERS	2008-06-09 14:35:20.007598587 -0700
@@ -1207,6 +1207,7 @@ M:	pj@sgi.com
 M:	menage@google.com
 L:	linux-kernel@vger.kernel.org
 W:	http://www.bullopensource.org/cpuset/
+W:	http://oss.sgi.com/projects/cpusets/
 S:	Supported
 
 CRAMFS FILESYSTEM

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
