Return-Path: <linux-kernel-owner+w=401wt.eu-S1030303AbXHMJbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030303AbXHMJbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966959AbXHMGck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:40 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1205 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965601AbXHMGci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:38 -0400
Date: Sun, 12 Aug 2007 23:32:21 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       andrewtv@usa.net, akpm@linux-foundation.org
Subject: [PATCH] [328/2many] MAINTAINERS - MULTISOUND SOUND DRIVER
Message-ID: <46bffaf5.F4N8l1t8/XwIpQbz%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b9748db..c74e9a6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3148,6 +3148,8 @@ MULTISOUND SOUND DRIVER
 P:	Andrew Veliath
 M:	andrewtv@usa.net
 S:	Maintained
+F:	Documentation/sound/oss/MultiSound
+F:	sound/oss/msnd*
 
 MULTITECH MULTIPORT CARD (ISICOM)
 P:	Jiri Slaby
