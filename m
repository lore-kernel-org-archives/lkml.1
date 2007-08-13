Return-Path: <linux-kernel-owner+w=401wt.eu-S972054AbXHMJwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S972054AbXHMJwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965786AbXHMGdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:33:47 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1388 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967125AbXHMGdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:37 -0400
Date: Sun, 12 Aug 2007 23:33:23 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, olof@lixom.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [361/2many] MAINTAINERS - PA SEMI ETHERNET DRIVER
Message-ID: <46bffb33.aYYLHYRpFYynyAfd%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f374fa8..c488769 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3470,6 +3470,7 @@ P:	Olof Johansson
 M:	olof@lixom.net
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/pasemi_mac.*
 
 PA SEMI SMBUS DRIVER
 P:	Olof Johansson
