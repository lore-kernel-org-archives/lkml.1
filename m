Return-Path: <linux-kernel-owner+w=401wt.eu-S1751339AbYGWHdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339AbYGWHdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 03:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbYGWHc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 03:32:58 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:50044 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753601AbYGWHc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 03:32:57 -0400
X-Sasl-enc: GbDK16aT5d9sZlUEz5KH5Sl38lOB6H1w4vQvJmXgKyDG 1216798375
Message-ID: <4886DEA4.4080607@ladisch.de>
Date: Wed, 23 Jul 2008 09:32:52 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] clarify HPET maintainer entry
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing HPET maintainer entries are somewhat unclear about which
one applies to what part of the kernel.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

--- a/MAINTAINERS	2008-07-23 08:43:53.000000000 +0200
+++ b/MAINTAINERS	2008-07-23 08:45:20.000000000 +0200
@@ -1931,7 +1931,7 @@
 M:	carlos@strangeworlds.co.uk
 S:	Odd Fixes

-HPET:	High Precision Event Timers driver (hpet.c)
+HPET:	High Precision Event Timers driver (drivers/char/hpet.c)
 P:	Clemens Ladisch
 M:	clemens@ladisch.de
 S:	Maintained
