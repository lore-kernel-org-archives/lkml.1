Return-Path: <linux-kernel-owner+w=401wt.eu-S942078AbXHMILH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942078AbXHMILH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966633AbXHMG2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:28:23 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4458 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965610AbXHMG2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:28:18 -0400
Date: Sun, 12 Aug 2007 23:28:02 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org
Subject: [PATCH] [201/2many] MAINTAINERS - FREEVXFS FILESYSTEM
Message-ID: <46bff9f2.6alWOF0jJ4L0f+lJ%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index a6a9366..e1d3ee3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1929,6 +1929,7 @@ P:	Christoph Hellwig
 M:	hch@infradead.org
 W:	ftp://ftp.openlinux.org/pub/people/hch/vxfs
 S:	Maintained
+F:	fs/freevxfs/
 
 FUJITSU FR-V (FRV) PORT
 P:	David Howells
