Return-Path: <linux-kernel-owner+w=401wt.eu-S945051AbXHMMCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S945051AbXHMMCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:02:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967519AbXHMGkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:40:07 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2462 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967496AbXHMGkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:40:02 -0400
Date: Sun, 12 Aug 2007 23:39:47 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-x25@vger.kernel.org,
       linux-kernel@vger.kernel.org, eis@baty.hanse.de,
       akpm@linux-foundation.org
Subject: [PATCH] [544/2many] MAINTAINERS - X.25 NETWORK LAYER
Message-ID: <46bffcb3.0Xk9br6H8RHWXTjQ%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 454494e..e4e1cc3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5141,6 +5141,9 @@ P:	Henner Eisen
 M:	eis@baty.hanse.de
 L:	linux-x25@vger.kernel.org
 S:	Maintained
+F:	Documentation/networking/x25*
+F:	include/net/x25*
+F:	net/x25/
 
 XEN HYPERVISOR INTERFACE
 P:	Jeremy Fitzhardinge
