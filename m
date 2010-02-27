Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936244Ab0B0VdU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 16:33:20 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43197 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933964Ab0B0VdS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 16:33:18 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-media <linux-media@vger.kernel.org>
In-Reply-To: <1267306076.16186.103.camel@localhost>
References: <1267306076.16186.103.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 27 Feb 2010 21:33:15 +0000
Message-ID: <1267306395.16186.110.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH firmware 6/6] Add firmware for lgs8g75
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is taken from the lgs8gxx driver as of 2.6.32-rc5.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
The binary changes are omitted from this message as they are impossible
to review.

Ben.

 WHENCE     |    9 +++++++++
 lgs8g75.fw |  Bin 0 -> 262 bytes
 2 files changed, 9 insertions(+), 0 deletions(-)
 create mode 100644 lgs8g75.fw

diff --git a/WHENCE b/WHENCE
index d62468e..659e255 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1184,3 +1184,12 @@ Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
+Driver: lgs8gxx - Legend Silicon GB20600 demodulator driver
+
+File: lgs8g75.fw
+
+Licence: Unknown
+
+Found in hex form in kernel source.
+
+--------------------------------------------------------------------------

