Return-Path: <linux-kernel-owner+w=401wt.eu-S1762573AbZAWBW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762573AbZAWBW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760281AbZAWBPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:15:16 -0500
Received: from kroah.org ([198.145.64.141]:50626 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760047AbZAWBPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:15:02 -0500
Date: Thu, 22 Jan 2009 17:12:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Florian Fainelli <florian@openwrt.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 24/46] r6040: bump release number to 0.19
Message-ID: <20090123011219.GY19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="r6040-bump-release-number-to-0.19.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Florian Fainelli <florian@openwrt.org>

[ Upstream commit: 4707470ae7441733822efcd680b0ef3971921c4d ]

This patch bumps the release number of the driver.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r6040.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/r6040.c
+++ b/drivers/net/r6040.c
@@ -49,8 +49,8 @@
 #include <asm/processor.h>
 
 #define DRV_NAME	"r6040"
-#define DRV_VERSION	"0.18"
-#define DRV_RELDATE	"13Jul2008"
+#define DRV_VERSION	"0.19"
+#define DRV_RELDATE	"18Dec2008"
 
 /* PHY CHIP Address */
 #define PHY1_ADDR	1	/* For MAC1 */

