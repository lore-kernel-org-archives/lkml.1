Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbYKKOvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbYKKOvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 09:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbYKKOvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 09:51:17 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40805 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755479AbYKKOvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 09:51:17 -0500
Date: Tue, 11 Nov 2008 14:51:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] telephony: trivial: fix up email address
Message-ID: <20081111145123.348f5364@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/telephony/phonedev.c b/drivers/telephony/phonedev.c
index 37caf4d..b52cc83 100644
--- a/drivers/telephony/phonedev.c
+++ b/drivers/telephony/phonedev.c
@@ -8,7 +8,7 @@
  *              as published by the Free Software Foundation; either version
  *              2 of the License, or (at your option) any later version.
  *
- * Author:      Alan Cox, <alan@redhat.com>
+ * Author:      Alan Cox, <alan@lxorguk.ukuu.org.uk>
  *
  * Fixes:       Mar 01 2000 Thomas Sparr, <thomas.l.sparr@telia.com>
  *              phone_register_device now works with unit!=PHONE_UNIT_ANY

diff --git a/include/linux/telephony.h b/include/linux/telephony.h
index 5b2b626..f63afe3 100644
--- a/include/linux/telephony.h
+++ b/include/linux/telephony.h
@@ -14,7 +14,7 @@
  *    Authors:       Ed Okerson, <eokerson@quicknet.net>
  *                   Greg Herlein, <gherlein@quicknet.net>
  *
- *    Contributors:  Alan Cox, <alan@redhat.com>
+ *    Contributors:  Alan Cox, <alan@lxorguk.ukuu.org.uk>
  *                   David W. Erhart, <derhart@quicknet.net>
  *
  * IN NO EVENT SHALL QUICKNET TECHNOLOGIES, INC. BE LIABLE TO ANY PARTY FOR
