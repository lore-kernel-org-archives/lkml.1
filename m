Return-Path: <linux-kernel-owner+w=401wt.eu-S1761455AbXHMGuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761455AbXHMGuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965777AbXHMGX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:27 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3643 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965870AbXHMGX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:23:26 -0400
Date: Sun, 12 Aug 2007 23:22:40 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, stelian@popies.net,
       linux-kernel@vger.kernel.org, linux-kernel@hansmi.ch,
       akpm@linux-foundation.org
Subject: [PATCH] [41/2many] MAINTAINERS - AMS (Apple Motion Sensor) DRIVER
Message-ID: <46bff8b0.JhFVUDfXiqPuQ4ng%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 35ebb00..635d812 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -403,6 +403,7 @@ M:	stelian@popies.net
 P:	Michael Hanselmann
 M:	linux-kernel@hansmi.ch
 S:	Supported
+F:	drivers/hwmon/ams/
 
 AMSO1100 RNIC DRIVER
 P:	Tom Tucker
