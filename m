Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbZHGQnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbZHGQnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 12:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbZHGQnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 12:43:16 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2056 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbZHGQnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 12:43:15 -0400
Subject: [PATCH] MAINTAINERS: additional NETWORKING [GENERAL] and
 NETWORKING DRIVERS patterns
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: sposelenov@emcraft.com, linux-kernel@vger.kernel.org, wd@denx.de,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090807.090353.191304972.davem@davemloft.net>
References: <20090618183738.662f7ef1@emcraft.com>
	 <20090807153106.335b1b8f@emcraft.com>
	 <20090807.090353.191304972.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 09:43:01 -0700
Message-Id: <1249663381.3467.80.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 09:03 -0700, David Miller wrote:
> From: Sergei Poselenov <sposelenov@emcraft.com>
> > Unfortunately, received no replies, but the problem still persists.
> I guarantee you'll get more responses if you send networking bug
> reports at least CC:'d to netdev@vger.kernel.org

Perhaps this will help get cc's to the right places.

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b1114cf..0b697a1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3555,6 +3555,9 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
 S:	Maintained
 F:	net/
 F:	include/net/
+F:	include/linux/in.h
+F:	include/linux/net.h
+F:	include/linux/netdevice.h
 
 NETWORKING [IPv4/IPv6]
 M:	"David S. Miller" <davem@davemloft.net>
@@ -3590,6 +3593,8 @@ W:	http://www.linuxfoundation.org/en/Net
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
 S:	Odd Fixes
 F:	drivers/net/
+F:	include/linux/if_*
+F:	include/linux/*device.h
 
 NETXEN (1/10) GbE SUPPORT
 M:	Dhananjay Phadke <dhananjay@netxen.com>


