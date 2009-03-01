Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbZCAJXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbZCAJXw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 04:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbZCAJVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 04:21:33 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:46206 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbZCAJVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 04:21:21 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 4/6] MAINTAINERS: Replace dead link to m68k CVS repository by link to new git repository
Date: Sun,  1 Mar 2009 10:21:13 +0100
Message-Id: <1235899275-23630-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1235899275-23630-4-git-send-email-geert@linux-m68k.org>
References: <1235899275-23630-1-git-send-email-geert@linux-m68k.org>
 <1235899275-23630-2-git-send-email-geert@linux-m68k.org>
 <1235899275-23630-3-git-send-email-geert@linux-m68k.org>
 <1235899275-23630-4-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CVS is dead, long live git!

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 59fd2d1..5e7f1db 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2834,7 +2834,7 @@ P:	Roman Zippel
 M:	zippel@linux-m68k.org
 L:	linux-m68k@lists.linux-m68k.org
 W:	http://www.linux-m68k.org/
-W:	http://linux-m68k-cvs.ubb.ca/
+T:	git git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git
 S:	Maintained
 
 M68K ON APPLE MACINTOSH
-- 
1.6.1.3

