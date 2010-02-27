Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935829Ab0B0VcE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 16:32:04 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43190 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933964Ab0B0VcA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 16:32:00 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1267306076.16186.103.camel@localhost>
References: <1267306076.16186.103.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 27 Feb 2010 21:31:57 +0000
Message-ID: <1267306317.16186.108.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH firmware 4/6] Update firmware from rt2870sta
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
The binary changes are omitted from this message as they are impossible
to review.

Ben.

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
 

