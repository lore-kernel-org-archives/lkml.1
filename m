Return-Path: <linux-kernel-owner+w=401wt.eu-S1767790AbXCJEJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767790AbXCJEJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 23:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767787AbXCJEJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 23:09:39 -0500
Received: from ns2.suse.de ([195.135.220.15]:36907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767776AbXCJEJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 23:09:28 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?J=C3=B6rn_Engel?= <joern@lazybastard.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/5] Remove devfs from MAINTAINERS
Date: Fri,  9 Mar 2007 20:07:30 -0800
Message-Id: <1173499658766-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0.2
In-Reply-To: <11734996551193-git-send-email-gregkh@suse.de>
References: <20070310040405.GC30638@kroah.com> <11734996523796-git-send-email-gregkh@suse.de> <11734996551193-git-send-email-gregkh@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jörn Engel <joern@lazybastard.org>

Remove last remaining trace of devfs.

Signed-off-by: JÃ¶rn Engel <joern@wohnheim.fh-wedel.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 MAINTAINERS |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9993b90..17555bb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1103,9 +1103,6 @@ W:	http://lanana.org/docs/device-list/index.html
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
-DEVICE FILESYSTEM
-S:	Obsolete
-
 DIGI INTL. EPCA DRIVER
 P:	Digi International, Inc
 M:	Eng.Linux@digi.com
-- 
1.5.0.2

