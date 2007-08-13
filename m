Return-Path: <linux-kernel-owner+w=401wt.eu-S944946AbXHMLxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944946AbXHMLxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967455AbXHMGjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:39:43 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2397 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966083AbXHMGjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:39:41 -0400
Date: Sun, 12 Aug 2007 23:39:24 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dushistov@mail.ru, akpm@linux-foundation.org
Subject: [PATCH] [532/2many] MAINTAINERS - UFS FILESYSTEM
Message-ID: <46bffc9c.6zgFXzddB2gPM1U+%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 671bb8d..b2f0e47 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5027,6 +5027,8 @@ P:	Evgeniy Dushistov
 M:	dushistov@mail.ru
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/filesystems/ufs.txt
+F:	fs/ufs/
 
 USB DIAMOND RIO500 DRIVER
 P:	Cesar Miquel
