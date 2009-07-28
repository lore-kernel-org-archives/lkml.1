Return-Path: <linux-kernel-owner+w=401wt.eu-S1755354AbZG1SH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbZG1SH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 14:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbZG1SH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 14:07:27 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1268 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbZG1SH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 14:07:26 -0400
Subject: [PATCH] MAINTAINERS: Add networking wireless drivers section
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>,
       "John W. Linville" <linville@tuxdriver.com>
Cc: julia@diku.dk, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20090728.103044.179053537.davem@davemloft.net>
References: <Pine.LNX.4.64.0907281753540.28189@ask.diku.dk>
	 <20090728.103044.179053537.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 28 Jul 2009 11:06:37 -0700
Message-Id: <1248804397.18284.5.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-28 at 10:30 -0700, David Miller wrote:
> Wireless patches need to be CC:'d to linux-wireless so that
> John Linville can notice and pick them up

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index ebc2691..0574aad 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4186,6 +4186,12 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
 S:	Odd Fixes
 F:	drivers/net/
 
+NETWORKING WIRELESS DRIVERS
+L:	linux-wireless@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
+S:	Odd Fixes
+F:	drivers/net/wireless/
+
 NETXEN (1/10) GbE SUPPORT
 P:	Dhananjay Phadke
 M:	dhananjay@netxen.com


