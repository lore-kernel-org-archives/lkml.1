Return-Path: <linux-kernel-owner+w=401wt.eu-S944294AbXHMLQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944294AbXHMLQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939158AbXHMGiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:04 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2094 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967310AbXHMGhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:39 -0400
Date: Sun, 12 Aug 2007 23:37:25 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, mulix@mulix.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [481/2many] MAINTAINERS - TRIDENT 4DWAVE/SIS 7018 PCI
 AUDIO CORE
Message-ID: <46bffc25.miV0BBr9F/41UwE2%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 7927653..fbd699e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4563,6 +4563,7 @@ P:	Muli Ben-Yehuda
 M:	mulix@mulix.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	sound/pci/trident/
 
 TRIVIAL PATCHES
 P:	Adrian Bunk
