Return-Path: <linux-kernel-owner+w=401wt.eu-S965398AbXHMLUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965398AbXHMLUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967231AbXHMGiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:13 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2106 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937893AbXHMGho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:44 -0400
Date: Sun, 12 Aug 2007 23:37:31 -0700
From: joe@perches.com
To: vtun@office.satix.net, torvalds@linux-foundation.org, maxk@qualcomm.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [484/2many] MAINTAINERS - TUN/TAP driver
Message-ID: <46bffc2b.YAK/RS1/wY7h95Js%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b8806b8..1fe5487 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4594,6 +4594,8 @@ M:	maxk@qualcomm.com
 L:	vtun@office.satix.net
 W:	http://vtun.sourceforge.net/tun
 S:	Maintained
+F:	Documentation/networking/tuntap.txt
+F:	arch/um/os-Linux/drivers/
 
 TURBOCHANNEL SUBSYSTEM
 P:	Maciej W. Rozycki
