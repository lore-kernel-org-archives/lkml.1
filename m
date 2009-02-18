Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbZBRBES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbZBRBES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbZBRBEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:04:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50036 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbZBRBEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:04:04 -0500
Message-ID: <499B5E8B.7030108@cn.fujitsu.com>
Date: Wed, 18 Feb 2009 09:04:11 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: README: fix a wrong link
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should be Documentation/build/kconfig.txt.

Introduced by commit 2af238e455ef5fd31c2f7a06c2db3f13d843b9bf
("kbuild: make *config usage docs").

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 README |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/README b/README
index 90a0765..d6c6c74 100644
--- a/README
+++ b/README
@@ -188,7 +188,7 @@ CONFIGURING the kernel:
 			   values to random values.
 
    You can find more information on using the Linux kernel config tools
-   in Documentation/kbuild/make-configs.txt.
+   in Documentation/kbuild/kconfig.txt.
 
 	NOTES on "make config":
 	- having unnecessary drivers will make the kernel bigger, and can
-- 
1.5.4.rc3

