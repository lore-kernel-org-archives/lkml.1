Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbZKTS0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbZKTS0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 13:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbZKTS0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 13:26:09 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:50543 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbZKTS0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 13:26:08 -0500
Date: Fri, 20 Nov 2009 19:26:13 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] kbuild: Steppeing down as Maintainer
Message-ID: <20091120182613.GA28307@merkur.ravnborg.org>
References: <20091120182249.GA28251@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091120182249.GA28251@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has been fun but the last year or more it has
been a duty and a burden. So I leave it open for
other to take over.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
diff --git a/MAINTAINERS b/MAINTAINERS
index c824b4d..147ec86 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2987,11 +2987,8 @@ S:	Maintained
 F:	fs/autofs4/
 
 KERNEL BUILD
-M:	Sam Ravnborg <sam@ravnborg.org>
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-next.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git
 L:	linux-kbuild@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	Documentation/kbuild/
 F:	Makefile
 F:	scripts/Makefile.*
