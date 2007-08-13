Return-Path: <linux-kernel-owner+w=401wt.eu-S1765488AbXHMKes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765488AbXHMKes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966720AbXHMGf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:35:59 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1784 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967161AbXHMGfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:50 -0400
Date: Sun, 12 Aug 2007 23:35:36 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, pfg@sgi.com, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [429/2many] MAINTAINERS - SGI SN-IA64 (Altix) SERIAL
 CONSOLE DRIVER
Message-ID: <46bffbb8.4fakUMLGtqE0GdFV%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 016cd0c..a4aa6af 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4084,6 +4084,7 @@ P:	Pat Gefre
 M:	pfg@sgi.com
 L:	linux-ia64@vger.kernel.org
 S:	Supported
+F:	Documentation/ia64/serial.txt
 
 SGI VISUAL WORKSTATION 320 AND 540
 P:	Andrey Panin
