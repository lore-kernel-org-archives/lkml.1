Return-Path: <linux-kernel-owner+w=401wt.eu-S939663AbXHMGxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939663AbXHMGxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965933AbXHMGXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:37 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3676 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965298AbXHMGXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:23:36 -0400
Date: Sun, 12 Aug 2007 23:22:44 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, johannes@sipsolutions.net,
       akpm@linux-foundation.org
Subject: [PATCH] [43/2many] MAINTAINERS - AOA (Apple Onboard Audio) ALSA
 DRIVER
Message-ID: <46bff8b4.nGsvrO+zx5IWj+A6%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e2e88f3..016f342 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -420,6 +420,7 @@ M:	johannes@sipsolutions.net
 L:	linuxppc-dev@ozlabs.org
 L:	alsa-devel@alsa-project.org (subscribers-only)
 S:	Maintained
+F:	sound/oao/
 
 APM DRIVER
 P:	Stephen Rothwell
