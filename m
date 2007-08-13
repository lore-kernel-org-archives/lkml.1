Return-Path: <linux-kernel-owner+w=401wt.eu-S938186AbXHMMQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938186AbXHMMQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967451AbXHMGlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:41:04 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2526 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967573AbXHMGlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:41:01 -0400
Date: Sun, 12 Aug 2007 23:35:34 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, jgarzik@pobox.com, akpm@linux-foundation.org
Subject: [PATCH] [428/2many] MAINTAINERS - SERIAL ATA (SATA) SUBSYSTEM:
Message-ID: <46bffbb6.4FinvGMu+SlIxG24%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 04c969c..016cd0c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4077,6 +4077,7 @@ M:	jgarzik@pobox.com
 L:	linux-ide@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
 S:	Supported
+F:	drivers/ata/sata_*
 
 SGI SN-IA64 (Altix) SERIAL CONSOLE DRIVER
 P:	Pat Gefre
