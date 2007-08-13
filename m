Return-Path: <linux-kernel-owner+w=401wt.eu-S942255AbXHMHkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942255AbXHMHkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966293AbXHMG0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:23 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4144 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966118AbXHMG0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:19 -0400
Date: Sun, 12 Aug 2007 23:26:01 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       garloff@suse.de, g.liakhovetski@gmx.de, akpm@linux-foundation.org
Subject: [PATCH] [147/2many] MAINTAINERS - DC390/AM53C974 SCSI driver
Message-ID: <46bff979.8vY8lnmEqoTHeHYr%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index d781d38..7f54480 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1426,6 +1426,7 @@ W:	http://www.garloff.de/kurt/linux/dc390/
 P:	Guennadi Liakhovetski
 M:	g.liakhovetski@gmx.de
 S:	Maintained
+F:	drivers/scsi/tmscsim.*
 
 DCCP PROTOCOL
 P:	Arnaldo Carvalho de Melo
