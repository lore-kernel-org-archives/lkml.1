Return-Path: <linux-kernel-owner+w=401wt.eu-S938672AbXHMK0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938672AbXHMK0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967264AbXHMGf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:35:29 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1698 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967246AbXHMGfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:21 -0400
Date: Sun, 12 Aug 2007 23:35:05 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux390@de.ibm.com,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
       fpavlic@de.ibm.com, akpm@linux-foundation.org
Subject: [PATCH] [413/2many] MAINTAINERS - S390 NETWORK DRIVERS
Message-ID: <46bffb99.DLqG1Vss26ZTcy37%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 21b14d4..8589439 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3939,6 +3939,7 @@ M:	linux390@de.ibm.com
 L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
 S:	Supported
+F:	drivers/s390/net/
 
 S390 ZFCP DRIVER
 P:	Swen Schillig
