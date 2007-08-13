Return-Path: <linux-kernel-owner+w=401wt.eu-S937657AbXHMHKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937657AbXHMHKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966050AbXHMGYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:37 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3831 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965958AbXHMGYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:32 -0400
Date: Sun, 12 Aug 2007 23:24:19 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, tigran@aivazian.fsnet.co.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [93/2many] MAINTAINERS - BFS FILE SYSTEM
Message-ID: <46bff913.JOLYFmLEaqodPbtA%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 2f452df..c8611db 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -944,6 +944,7 @@ P:	Tigran A. Aivazian
 M:	tigran@aivazian.fsnet.co.uk
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	fs/bfs/
 
 BLACKFIN I2C TWI DRIVER
 P:	Sonic Zhang
