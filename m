Return-Path: <linux-kernel-owner+w=401wt.eu-S967295AbXHMISi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967295AbXHMISi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966717AbXHMG2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:28:44 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4527 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966705AbXHMG2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:28:43 -0400
Date: Sun, 12 Aug 2007 23:28:27 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, parisc-linux@lists.parisc-linux.org,
       linux-kernel@vger.kernel.org, kyle@parisc-linux.org,
       akpm@linux-foundation.org
Subject: [PATCH] [213/2many] MAINTAINERS - HARMONY SOUND DRIVER
Message-ID: <46bffa0b.TnOemsyQXUc9pi4J%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 0b6b514..b8aaabd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2039,6 +2039,7 @@ M:	kyle@parisc-linux.org
 W:	http://www.parisc-linux.org/~kyle/harmony/
 L:	parisc-linux@lists.parisc-linux.org
 S:	Maintained
+F:	/sound/parisc/harmony.*
 
 HAYES ESP SERIAL DRIVER
 P:	Andrew J. Robinson
