Return-Path: <linux-kernel-owner+w=401wt.eu-S968841AbXHMICk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968841AbXHMICk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966399AbXHMG1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:27:47 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4384 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966361AbXHMG1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:27:45 -0400
Date: Sun, 12 Aug 2007 23:27:28 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kevin.curtis@farsite.co.uk, akpm@linux-foundation.org
Subject: [PATCH] [190/2many] MAINTAINERS - FARSYNC SYNCHRONOUS DRIVER
Message-ID: <46bff9d0.I7njF7OiyopLQwQx%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 73ce5d8..3d01240 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1832,6 +1832,7 @@ P:	Kevin Curtis
 M:	kevin.curtis@farsite.co.uk
 W:	http://www.farsite.co.uk/
 S:	Supported
+F:	drivers/net/wan/farsync.*
 
 FAULT INJECTION SUPPORT
 P:	Akinobu Mita
