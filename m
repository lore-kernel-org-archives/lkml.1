Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303Ab0AWJPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab0AWJPp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 04:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526Ab0AWJPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 04:15:44 -0500
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:41750 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751082Ab0AWJPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 04:15:43 -0500
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-2.6 PATCH] MAINTAINERS: Add Intel igbvf maintainer
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, gospo@redhat.com, linux-kernel@vger.kernel.org,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Sat, 23 Jan 2010 01:15:26 -0800
Message-ID: <20100123091502.10912.25678.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add igbvf to the list of supported Intel drivers and Alex to the list of
maintainers.

Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---

 MAINTAINERS |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ef40d2c..1f0ba17 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2803,10 +2803,11 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ixp2000/
 
-INTEL ETHERNET DRIVERS (e100/e1000/e1000e/igb/ixgb/ixgbe)
+INTEL ETHERNET DRIVERS (e100/e1000/e1000e/igb/igbvf/ixgb/ixgbe)
 M:	Jeff Kirsher <jeffrey.t.kirsher@intel.com>
 M:	Jesse Brandeburg <jesse.brandeburg@intel.com>
 M:	Bruce Allan <bruce.w.allan@intel.com>
+M:	Alex Duyck <alexander.h.duyck@intel.com>
 M:	PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>
 M:	John Ronciak <john.ronciak@intel.com>
 L:	e1000-devel@lists.sourceforge.net
@@ -2816,6 +2817,7 @@ F:	drivers/net/e100.c
 F:	drivers/net/e1000/
 F:	drivers/net/e1000e/
 F:	drivers/net/igb/
+F:	drivers/net/igbvf/
 F:	drivers/net/ixgb/
 F:	drivers/net/ixgbe/
 

