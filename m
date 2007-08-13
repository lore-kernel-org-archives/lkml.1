Return-Path: <linux-kernel-owner+w=401wt.eu-S971339AbXHMJPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971339AbXHMJPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966994AbXHMGbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:53 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1067 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966379AbXHMGbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:49 -0400
Date: Sun, 12 Aug 2007 23:31:37 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, philb@gnu.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [306/2many] MAINTAINERS - M68K ON HP9000/300
Message-ID: <46bffac9.sLFfcCXmwhWEs6rS%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b01052d..f7943f0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2945,6 +2945,8 @@ P:	Philip Blundell
 M:	philb@gnu.org
 W:	http://www.tazenda.demon.co.uk/phil/linux-hp
 S:	Maintained
+F:	arch/m68k/hp300/
+F:	include/asm-m68k/hp*
 
 MAC80211
 P:	Jiri Benc
