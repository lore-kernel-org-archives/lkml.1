Return-Path: <linux-kernel-owner+w=401wt.eu-S967194AbXHMGe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967194AbXHMGe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965448AbXHMGWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:22:48 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3511 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965017AbXHMGWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:22:41 -0400
Date: Sun, 12 Aug 2007 23:21:54 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org, bcrl@kvack.org, akpm@linux-foundation.org
Subject: [PATCH] [16/2many] MAINTAINERS - AIO
Message-ID: <46bff882.6u01/hQrI4oBP5M+%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 7989432..2de2083 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -201,6 +201,8 @@ P:	Benjamin LaHaise
 M:	bcrl@kvack.org
 L:	linux-aio@kvack.org
 S:	Supported
+F:	fs/aio.c
+F:	include/linux/*aio*.h
 
 ABIT UGURU HARDWARE MONITOR DRIVER
 P:	Hans de Goede
