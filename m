Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000Ab0AQOrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab0AQOrS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 09:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941Ab0AQOrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 09:47:17 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43194 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753576Ab0AQOrQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 09:47:16 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1263738961.8876.28.camel@localhost>
References: <1263738961.8876.28.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 17 Jan 2010 14:43:15 +0000
Message-ID: <1263739395.8876.33.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 5/5] Add RT3090 firmware from rt2860sta
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 WHENCE     |   10 ++++++++++
 rt3090.bin |  Bin 0 -> 8192 bytes
 2 files changed, 10 insertions(+), 0 deletions(-)
 create mode 100644 rt3090.bin

diff --git a/WHENCE b/WHENCE
index ffc9248..d62468e 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1000,6 +1000,16 @@ Downloaded from http://www.ralinktech.com/ralink/Home/Support/Linux.html
 
 --------------------------------------------------------------------------
 
+Driver: rt2860sta - Ralink RT3090 wireless MACs
+
+File: rt3090.bin
+
+Licence: Redistributable. See LICENCE.ralink-firmware.txt for details
+
+Found in hex form in kernel source.
+
+--------------------------------------------------------------------------
+
 Driver: rt2870sta - Ralink RT2870, RT3070, RT3071, RT3072 wireless MACs
 
 File: rt2870.bin
diff --git a/rt3090.bin b/rt3090.bin
new file mode 100644
index 0000000..d8f0925
Binary files /dev/null and b/rt3090.bin differ
-- 
1.6.6


