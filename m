Return-Path: <linux-kernel-owner+w=401wt.eu-S1763471AbZFNUxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763471AbZFNUxr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 16:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757838AbZFNUxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 16:53:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60497 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbZFNUxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 16:53:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] asm-generic: list Arnd as asm-generic maintainer
Date: Sun, 14 Jun 2009 22:53:35 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-arch@vger.kernel.org, Joe Perches <joe@perches.com>
References: <200906112146.32441.arnd@arndb.de>
In-Reply-To: <200906112146.32441.arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?iso-8859-1?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-1?q?Y=2Ea=5E3zb?=)
 =?iso-8859-1?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-1?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906142253.35550.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+vH6Dl18ymCGY+//YOpFXX0CcLHdJ3vE58Qev
 NgtlIQaG9PCnJnrF1uJjmJWKKowO4VO9faSgQitdRGhmmDKMnM
 IpF8msCfXyzniTZtLgXh37i59I/rQno
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've modified about half the code in include/asm-generic now, and
people start sending me patches for it, so I should probably take
the formal responsibility for it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

I've already added this patch to my asm-generic tree and plan to push it
along with the patches I got from Mike Frysinger.

diff --git a/MAINTAINERS b/MAINTAINERS
index 90f8128..f35f12e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2436,6 +2436,14 @@ F:	drivers/net/wan/pc300too.c
 F:	drivers/net/wan/pci200syn.c
 F:	drivers/net/wan/wanxl*
 
+GENERIC INCLUDE/ASM HEADER FILES
+P:	Arnd Bergmann
+M:	arnd@arndb.de
+L:	linux-arch@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git
+S:	Maintained
+F:	include/asm-generic
+
 GFS2 FILE SYSTEM
 P:	Steven Whitehouse
 M:	swhiteho@redhat.com
-- 
1.6.3.1

