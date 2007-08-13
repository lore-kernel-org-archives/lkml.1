Return-Path: <linux-kernel-owner+w=401wt.eu-S944238AbXHMLPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944238AbXHMLPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939153AbXHMGiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:01 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2081 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967405AbXHMGhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:36 -0400
Date: Sun, 12 Aug 2007 23:37:21 -0700
From: joe@perches.com
To: toshiba_acpi@memebeam.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [479/2many] MAINTAINERS - TOSHIBA ACPI EXTRAS DRIVER
Message-ID: <46bffc21.JtPmgd+eEAODl3BW%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b5dc1ac..ba55e00 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4547,6 +4547,7 @@ P:	John Belmonte
 M:	toshiba_acpi@memebeam.org
 W:	http://memebeam.org/toys/ToshibaAcpiDriver
 S:	Maintained
+F:	drivers/acpi/toshiba_acpi.c
 
 TOSHIBA SMM DRIVER
 P:	Jonathan Buzzard
