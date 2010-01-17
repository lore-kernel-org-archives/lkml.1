Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986Ab0AQOqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab0AQOqs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 09:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882Ab0AQOqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 09:46:47 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43189 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753879Ab0AQOqq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 09:46:46 -0500
Subject: [PATCH firmware 4/5] Update firmware from rt2870sta
From: Ben Hutchings <ben@decadent.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1263738961.8876.28.camel@localhost>
References: <1263738961.8876.28.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 17 Jan 2010 14:42:40 +0000
Message-ID: <1263739360.8876.32.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SA Timed out after 240 secs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 WHENCE     |    6 ++++--
 rt2870.bin |  Bin 4096 -> 4096 bytes
 rt3070.bin |  Bin 0 -> 4096 bytes
 rt3071.bin |  Bin 0 -> 4096 bytes
 4 files changed, 4 insertions(+), 2 deletions(-)
 create mode 100644 rt3070.bin
 create mode 100644 rt3071.bin

diff --git a/WHENCE b/WHENCE
index 690157d..ffc9248 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1000,13 +1000,15 @@ Downloaded from http://www.ralinktech.com/ralink/Home/Support/Linux.html
 
 --------------------------------------------------------------------------
 
-Driver: rt2870sta - Ralink RT2870 wireless MACs
+Driver: rt2870sta - Ralink RT2870, RT3070, RT3071, RT3072 wireless MACs
 
 File: rt2870.bin
+File: rt3070.bin
+File: rt3071.bin
 
 Licence: Redistributable. See LICENCE.ralink-firmware.txt for details
 
-Downloaded from http://www.ralinktech.com/ralink/Home/Support/Linux.html
+Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
diff --git a/rt2870.bin b/rt2870.bin
index 9abc971..d94fc7e 100644
Binary files a/rt2870.bin and b/rt2870.bin differ
diff --git a/rt3070.bin b/rt3070.bin
new file mode 100644
index 0000000..cd49e96
Binary files /dev/null and b/rt3070.bin differ
diff --git a/rt3071.bin b/rt3071.bin
new file mode 100644
index 0000000..6db66b3
Binary files /dev/null and b/rt3071.bin differ
-- 
1.6.6



