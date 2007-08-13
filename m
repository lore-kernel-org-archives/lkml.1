Return-Path: <linux-kernel-owner+w=401wt.eu-S944147AbXHMLLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944147AbXHMLLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbXHMGhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:37:53 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2060 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967400AbXHMGh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:27 -0400
Date: Sun, 12 Aug 2007 23:37:14 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, roms@lpg.ticalc.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [475/2many] MAINTAINERS - TI PARALLEL LINK CABLE DRIVER
Message-ID: <46bffc1a.N1qcNk9je1SJ+iok%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 36186ab..1be2281 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4503,6 +4503,9 @@ TI PARALLEL LINK CABLE DRIVER
 P:	Romain Lievin
 M:	roms@lpg.ticalc.org
 S:	Maintained
+F:	Documentation/tipar.txt
+F:	drivers/char/tipar.c
+F:	include/linux/ticable.h
 
 TIPC NETWORK LAYER
 P:	Per Liden
