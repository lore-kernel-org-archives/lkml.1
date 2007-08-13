Return-Path: <linux-kernel-owner+w=401wt.eu-S936670AbXHMKT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936670AbXHMKT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967169AbXHMGfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:35:05 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1632 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967209AbXHMGe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:34:58 -0400
Date: Sun, 12 Aug 2007 23:34:44 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, mporter@kernel.crashing.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [402/2many] MAINTAINERS - RAPIDIO SUBSYSTEM
Message-ID: <46bffb84.nbB4r3XvF6NULNYT%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index a2484d5..776ca59 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3835,6 +3835,7 @@ P:	Matt Porter
 M:	mporter@kernel.crashing.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	drivers/rapidio/
 
 READ-COPY UPDATE (RCU)
 P:	Dipankar Sarma
