Return-Path: <linux-kernel-owner+w=401wt.eu-S1764210AbZFLJ4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764210AbZFLJ4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764181AbZFLJ40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:56:26 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:55895 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764174AbZFLJ4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:56:25 -0400
Subject: [PATCH 2/2] kmemleak: Add more info to the MAINTAINERS entry
To: Linus Torvalds <torvalds@linux-foundation.org>
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 12 Jun 2009 10:55:50 +0100
Message-ID: <20090612095550.14809.74365.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <1244800406.26670.29.camel@pc1117.cambridge.arm.com>
References: <1244800406.26670.29.camel@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.385.g1112
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jun 2009 09:55:50.0841 (UTC) FILETIME=[F7BC2A90:01C9EB43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds the "F:" fields to the KMEMLEAK MAINTAINERS entry and
also moves it before KMEMTRACE to preserve the alphabetical order.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 MAINTAINERS |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c944d61..f7d64fa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3363,6 +3363,16 @@ F:	drivers/serial/kgdboc.c
 F:	include/linux/kgdb.h
 F:	kernel/kgdb.c
 
+KMEMLEAK
+P:	Catalin Marinas
+M:	catalin.marinas@arm.com
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	Documentation/kmemleak.txt
+F:	include/linux/kmemleak.h
+F:	mm/kmemleak.c
+F:	mm/kmemleak-test.c
+
 KMEMTRACE
 P:	Eduard - Gabriel Munteanu
 M:	eduard.munteanu@linux360.ro
@@ -3372,12 +3382,6 @@ F:	Documentation/trace/kmemtrace.txt
 F:	include/trace/kmemtrace.h
 F:	kernel/trace/kmemtrace.c
 
-KMEMLEAK
-P:	Catalin Marinas
-M:	catalin.marinas@arm.com
-L:	linux-kernel@vger.kernel.org
-S:	Maintained
-
 KPROBES
 P:	Ananth N Mavinakayanahalli
 M:	ananth@in.ibm.com

