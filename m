Return-Path: <linux-kernel-owner+w=401wt.eu-S1762408AbYD2R2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762408AbYD2R2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758744AbYD2RVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:21:16 -0400
Received: from mx1.suse.de ([195.135.220.2]:52127 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758711AbYD2RVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:21:14 -0400
Date: Tue, 29 Apr 2008 10:18:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jeff@garzik.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       support@neterion.com, Santosh Rastapur <santosh.rastapur@neterion.com>,
       Ramkrishna Vepa <ram.vepa@neterion.com>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [19/37] S2io: Version update for memory leak fix during
	free_tx_buffers
Message-ID: <20080429171841.GT14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="s2io-version-update-for-memory-leak-fix-during-free_tx_buffers.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Sreenivasa Honnur <Sreenivasa.Honnur@neterion.com>

commit 10371b5e6ba22173425877ea6a7040619b005fa1 upstream

- Updated version number.

Signed-off-by: Santosh Rastapur <santosh.rastapur@neterion.com>
Signed-off-by: Ramkrishna Vepa <ram.vepa@neterion.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/s2io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -84,7 +84,7 @@
 #include "s2io.h"
 #include "s2io-regs.h"
 
-#define DRV_VERSION "2.0.26.20"
+#define DRV_VERSION "2.0.26.22"
 
 /* S2io Driver name & version. */
 static char s2io_driver_name[] = "Neterion";

-- 
