Return-Path: <linux-kernel-owner+w=401wt.eu-S1751152AbYCUXqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152AbYCUXqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYCUXpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 19:45:32 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:60159 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbYCUXpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 19:45:22 -0400
Message-Id: <20080321224333.400857992@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:42:57 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 07/76] NIU: Bump driver version and release date.
Content-Disposition: inline; filename=niu-bump-driver-version-and-release-date.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David S. Miller <davem@davemloft.net>

Upstream commit: a442585952f137bd4cdb1f2f3166e4157d383b82

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 drivers/net/niu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -33,8 +33,8 @@
 
 #define DRV_MODULE_NAME		"niu"
 #define PFX DRV_MODULE_NAME	": "
-#define DRV_MODULE_VERSION	"0.6"
-#define DRV_MODULE_RELDATE	"January 5, 2008"
+#define DRV_MODULE_VERSION	"0.7"
+#define DRV_MODULE_RELDATE	"February 18, 2008"
 
 static char version[] __devinitdata =
 	DRV_MODULE_NAME ".c:v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";

-- 
