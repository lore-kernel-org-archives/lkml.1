Return-Path: <linux-kernel-owner+w=401wt.eu-S1763671AbXHMKON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763671AbXHMKON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938433AbXHMGek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:34:40 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1565 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216AbXHMGef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:34:35 -0400
Date: Sun, 12 Aug 2007 23:34:21 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, mikpe@it.uu.se,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [390/2many] MAINTAINERS - PROMISE SATA TX2/TX4 CONTROLLER LIBATA DRIVER
Message-ID: <46bffb6d.0uoUvwTD9BzOVPUV%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f61f0a8..19f2a5f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3730,6 +3730,7 @@ P:	Mikael Pettersson
 M:	mikpe@it.uu.se
 L:	linux-ide@vger.kernel.org
 S:	Maintained
+F:	drivers/ata/sata_promise.*
 
 PS3 NETWORK SUPPORT
 P:	Masakazu Mokuno
