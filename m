Return-Path: <linux-kernel-owner+w=401wt.eu-S971551AbXHMJRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971551AbXHMJRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966902AbXHMGb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:58 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1086 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966987AbXHMGbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:55 -0400
Date: Sun, 12 Aug 2007 23:31:35 -0700
From: joe@perches.com
To: zippel@linux-m68k.org, torvalds@linux-foundation.org,
       linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       geert@linux-m68k.org, akpm@linux-foundation.org
Subject: [PATCH] [305/2many] MAINTAINERS - M68K ARCHITECTURE
Message-ID: <46bffac7.PW2ZV6M6KL1265zG%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e4ba367..b01052d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2930,6 +2930,8 @@ L:	linux-m68k@lists.linux-m68k.org
 W:	http://www.linux-m68k.org/
 W:	http://linux-m68k-cvs.ubb.ca/
 S:	Maintained
+F:	arch/m68k/
+F:	include/asm-m68k/
 
 M68K ON APPLE MACINTOSH
 P:	Joshua Thompson
