Return-Path: <linux-kernel-owner+w=401wt.eu-S969586AbXHMIfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969586AbXHMIfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966832AbXHMG3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:29:46 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4689 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966596AbXHMG3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:29:44 -0400
Date: Sun, 12 Aug 2007 23:29:30 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, stefanr@s5r6.in-berlin.de,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       dan@dennedy.org, akpm@linux-foundation.org
Subject: [PATCH] [245/2many] MAINTAINERS - IEEE 1394 RAW I/O DRIVER
 (raw1394)
Message-ID: <46bffa4a.mbhE/dzTT9J4IluU%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 26c460a..7889eb8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2321,6 +2321,7 @@ P:	Stefan Richter
 M:	stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/ieee1394/raw1394*
 
 IMS TWINTURBO FRAMEBUFFER DRIVER
 P:	Paul Mundt
