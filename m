Return-Path: <linux-kernel-owner+w=401wt.eu-S938018AbXHMHem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938018AbXHMHem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966166AbXHMG0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:07 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4097 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966238AbXHMG0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:01 -0400
Date: Sun, 12 Aug 2007 23:25:48 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jayakumar.alsa@gmail.com, akpm@linux-foundation.org
Subject: [PATCH] [140/2many] MAINTAINERS - CS5535 Audio ALSA driver
Message-ID: <46bff96c.J9yFP7daYOKvLMb1%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index bc2e348..26eeef8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1358,6 +1358,7 @@ CS5535 Audio ALSA driver
 P:	Jaya Kumar
 M:	jayakumar.alsa@gmail.com
 S:	Maintained
+F:	sound/pci/cs5535audio/
 
 CYBERPRO FB DRIVER
 P:	Russell King
