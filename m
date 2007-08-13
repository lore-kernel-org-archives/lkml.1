Return-Path: <linux-kernel-owner+w=401wt.eu-S940493AbXHMHK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940493AbXHMHK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966112AbXHMGYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:38 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3837 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965969AbXHMGYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:34 -0400
Date: Sun, 12 Aug 2007 23:24:21 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, sonic.zhang@analog.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [94/2many] MAINTAINERS - BLACKFIN I2C TWI DRIVER
Message-ID: <46bff915.8A2FR13OGw7TXwkz%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c8611db..7b84921 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -952,6 +952,7 @@ M:	sonic.zhang@analog.com
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org/
 S:	Supported
+F:	drivers/i2c/busses/i2c-bfin-twi.c
 
 BLOCK LAYER
 P:	Jens Axboe
