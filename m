Return-Path: <linux-kernel-owner+w=401wt.eu-S966069AbXHMIzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966069AbXHMIzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966757AbXHMGa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:30:58 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4877 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966860AbXHMGa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:30:57 -0400
Date: Sun, 12 Aug 2007 23:30:35 -0700
From: joe@perches.com
To: zippel@linux-m68k.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, kbuild-devel@lists.sourceforge.net,
       akpm@linux-foundation.org
Subject: [PATCH] [274/2many] MAINTAINERS - KCONFIG
Message-ID: <46bffa8b.TSnENJWsYXM+jRiQ%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3a9c079..1ea2c63 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2622,6 +2622,8 @@ P:	Roman Zippel
 M:	zippel@linux-m68k.org
 L:	kbuild-devel@lists.sourceforge.net
 S:	Maintained
+F:	Documentation/kbuild/kconfig-language.txt
+F:	scripts/kconfig/
 
 KDUMP
 P:	Vivek Goyal
