Return-Path: <linux-kernel-owner+w=401wt.eu-S1030241AbXHMJVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030241AbXHMJVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966949AbXHMGcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:17 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1136 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967009AbXHMGcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:13 -0400
Date: Sun, 12 Aug 2007 23:32:00 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, oliver@neukum.name,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [317/2many] MAINTAINERS - MICROTEK X6 SCANNER
Message-ID: <46bffae0.KP+YslNjkl3AdDHb%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 2667601..0c98162 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3053,6 +3053,7 @@ MICROTEK X6 SCANNER
 P:	Oliver Neukum
 M:	oliver@neukum.name
 S:	Maintained
+F:	drivers/usb/image/microtek.*
 
 MIPS
 P:	Ralf Baechle
