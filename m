Return-Path: <linux-kernel-owner+w=401wt.eu-S968865AbXHMIBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968865AbXHMIBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966538AbXHMG1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:27:46 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4383 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966324AbXHMG1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:27:44 -0400
Date: Sun, 12 Aug 2007 23:27:30 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, akinobu.mita@gmail.com
Subject: [PATCH] [191/2many] MAINTAINERS - FAULT INJECTION SUPPORT
Message-ID: <46bff9d2.IH6+JV2LUIuncRAP%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3d01240..0d92f67 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1838,6 +1838,8 @@ FAULT INJECTION SUPPORT
 P:	Akinobu Mita
 M:	akinobu.mita@gmail.com
 S:	Supported
+F:	Documentation/fault-injection/
+F:	lib/fault-inject.c
 
 FRAMEBUFFER LAYER
 P:	Antonino Daplas
