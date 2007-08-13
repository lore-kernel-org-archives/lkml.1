Return-Path: <linux-kernel-owner+w=401wt.eu-S942807AbXHMMGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942807AbXHMMGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967496AbXHMGkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:40:20 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2484 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967449AbXHMGkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:40:10 -0400
Date: Sun, 12 Aug 2007 23:26:46 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, mike@i-connect.net,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-eata@i-connect.net, akpm@linux-foundation.org
Subject: [PATCH] [168/2many] MAINTAINERS - EATA-PIO SCSI DRIVER
Message-ID: <46bff9a6.JgnkA2fWJL5dZFb2%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 144c052..45ce2d4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1631,8 +1631,10 @@ F:	drivers/scsi/eata*
 EATA-PIO SCSI DRIVER
 P:	Michael Neuffer
 M:	mike@i-Connect.Net
-L:	linux-eata@i-connect.net, linux-scsi@vger.kernel.org
+L:	linux-eata@i-connect.net
+L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/eata*
 
 EBTABLES
 P:	Bart De Schuymer
