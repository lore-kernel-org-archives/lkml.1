Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab0CDFyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 00:54:11 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59330 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab0CDFyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 00:54:08 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 4 Mar 2010 14:50:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       balbir@linux.vnet.ibm.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       nishimura@mxp.nes.nec.co.jp
Subject: [PATCH] memcg: update mainteiner list
Message-Id: <20100304145030.22a35a7e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updates for maintainer list of memcg.
I'd like to add Nishimura-san to maintainer of memcg, he works really well.
And I'm sorry that I've not seen Pavel on memcg discussion for a year.

==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Nishimura-san have been working for memcg very good.
His review and tests give us much improvements and account migraiton
which he is now challenging is really important.

He is a stakeholder.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: mmotm-2.6.33-Mar2/MAINTAINERS
===================================================================
--- mmotm-2.6.33-Mar2.orig/MAINTAINERS
+++ mmotm-2.6.33-Mar2/MAINTAINERS
@@ -3675,7 +3675,7 @@ F:	mm/
 
 MEMORY RESOURCE CONTROLLER
 M:	Balbir Singh <balbir@linux.vnet.ibm.com>
-M:	Pavel Emelyanov <xemul@openvz.org>
+M:	Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
 M:	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
 L:	linux-mm@kvack.org
 S:	Maintained

