Return-Path: <linux-kernel-owner+w=401wt.eu-S941833AbXHMKum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941833AbXHMKum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967273AbXHMGgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:40 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1872 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967226AbXHMGgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:36:23 -0400
Date: Sun, 12 Aug 2007 23:36:09 -0700
From: joe@perches.com
To: tsbogend@alpha.franken.de, torvalds@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [445/2many] MAINTAINERS - SONIC NETWORK DRIVER
Message-ID: <46bffbd9.eUTVbA8A6bfRCZGE%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e9e7a00..6175c77 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4233,6 +4233,7 @@ P:	Thomas Bogendoerfer
 M:	tsbogend@alpha.franken.de
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/sonic.*
 
 SONY VAIO CONTROL DEVICE DRIVER
 P:	Mattia Dongili
