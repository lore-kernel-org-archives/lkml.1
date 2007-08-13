Return-Path: <linux-kernel-owner+w=401wt.eu-S969399AbXHMI3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969399AbXHMI3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966778AbXHMG3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:29:15 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4608 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966675AbXHMG3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:29:13 -0400
Date: Sun, 12 Aug 2007 23:29:01 -0700
From: joe@perches.com
To: wli@holomorphy.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [230/2many] MAINTAINERS - HUGETLB FILESYSTEM
Message-ID: <46bffa2d.41YO8Vrk+2JUFity%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 1ea3fec..491a5a6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2185,6 +2185,7 @@ HUGETLB FILESYSTEM
 P:	William Irwin
 M:	wli@holomorphy.com
 S:	Maintained
+F:	fs/hugetlbfs/
 
 I2C/SMBUS STUB DRIVER
 P:	Mark M. Hoffman
