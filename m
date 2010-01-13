Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557Ab0AMV4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab0AMV4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:56:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756529Ab0AMV4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:56:11 -0500
Received: from mail.perches.com ([173.55.12.10]:1135 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756526Ab0AMV4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:56:08 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] MAINTAINERS: STARMODE RADIO IP (STRIP) moved to staging
Date: Wed, 13 Jan 2010 13:56:06 -0800
Message-Id: <42271a56643ee39c969ed57007410eb3cccb1c00.1263419518.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1263419518.git.joe@perches.com>
References: <cover.1263419518.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

by commit 955015bb0b42167d14f776ff5947ae2463a974dc

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index abd548e..80520a3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5146,7 +5146,7 @@ F:	drivers/net/starfire*
 
 STARMODE RADIO IP (STRIP) PROTOCOL DRIVER
 S:	Orphan
-F:	drivers/net/wireless/strip.c
+F:	drivers/staging/strip/strip.c
 F:	include/linux/if_strip.h
 
 STRADIS MPEG-2 DECODER DRIVER
-- 
1.6.6.rc0.57.gad7a

