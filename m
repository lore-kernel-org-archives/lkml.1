Return-Path: <linux-kernel-owner+w=401wt.eu-S939918AbXHMH1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939918AbXHMH1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966222AbXHMGZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:25:39 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4007 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966199AbXHMGZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:25:33 -0400
Date: Sun, 12 Aug 2007 23:25:17 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       joel.becker@oracle.com, akpm@linux-foundation.org
Subject: [PATCH] [124/2many] MAINTAINERS - CONFIGFS
Message-ID: <46bff94d.qyuCmMD210tMpr2u%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 5144e4e..e5853e8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1208,6 +1208,8 @@ P:	Joel Becker
 M:	joel.becker@oracle.com
 L:	linux-kernel@vger.kernel.org
 S:	Supported
+F:	fs/configfs/
+F:	include/linux/configfs.h
 
 CIRRUS LOGIC EP93XX ETHERNET DRIVER
 P:	Lennert Buytenhek
