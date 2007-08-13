Return-Path: <linux-kernel-owner+w=401wt.eu-S933635AbXHMHF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635AbXHMHF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966095AbXHMGYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:23 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3796 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965946AbXHMGYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:20 -0400
Date: Sun, 12 Aug 2007 23:24:04 -0700
From: joe@perches.com
To: yi.li@analog.com, vivi.li@analog.com, torvalds@linux-foundation.org,
       sonic.zhang@analog.com, roy.huang@analog.com, robin.getz@analog.com,
       michael.hennerich@analog.com, michael.frysinger@analog.com,
       marc.hoffman@analog.com, linux-kernel@vger.kernel.org,
       jie.zhang@analog.com, jerry.zeng@analog.com, grace.pan@analog.com,
       bryan.wu@analog.com, bernd.schmidt@analog.com, aubrey.li@analog.com,
       akpm@linux-foundation.org
Subject: [PATCH] [85/2many] MAINTAINERS - BLACKFIN ARCHITECTURE
Message-ID: <46bff904.ANPWrqncsP8VpmBH%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index a78c8e8..6afe57b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -877,6 +877,8 @@ M:	yi.li@analog.com
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org
 S:	Supported
+F:	arch/blackfin/
+F:	include/asm-blackfin/
 
 BLACKFIN EMAC DRIVER
 P:	Bryan Wu
