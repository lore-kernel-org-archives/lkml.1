Return-Path: <linux-kernel-owner+w=401wt.eu-S967813AbXHMGoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967813AbXHMGoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936529AbXHMGXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:08 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3574 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965808AbXHMGXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:23:01 -0400
Date: Sun, 12 Aug 2007 23:22:35 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, rth@twiddle.net,
       linux-kernel@vger.kernel.org, ink@jurassic.park.msu.ru,
       akpm@linux-foundation.org
Subject: [PATCH] [38/2many] MAINTAINERS - ALPHA PORT
Message-ID: <46bff8ab.Leyu26eEjtFyQZjC%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index eeb1bf9..e6c018d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -376,6 +376,7 @@ S:	Odd Fixes for 2.4; Maintained for 2.6.
 P:	Ivan Kokshaysky
 M:	ink@jurassic.park.msu.ru
 S:	Maintained for 2.4; PCI support for 2.6.
+F:	arch/alfa/
 
 AMD GEODE CS5536 USB DEVICE CONTROLLER DRIVER
 P:	Thomas Dahlmann
