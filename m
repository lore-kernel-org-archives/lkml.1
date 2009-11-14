Return-Path: <linux-kernel-owner+w=401wt.eu-S1757727AbZKNAZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727AbZKNAZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 19:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757602AbZKNAZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 19:25:43 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:59537 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbZKNAZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 19:25:43 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [RFC] MAINTAINERS: add SPI co-maintainer.
To: akpm@linux-foundation.org, dbrownell@users.sourceforge.net,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Fri, 13 Nov 2009 17:25:45 -0700
Message-ID: <20091114001001.5343.99566.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

Hi David, Andrew.

David, I know that you haven't had enough time lately to keep on top
of the pending SPI patches, so I was wondering if you would like some
help?  If you are interested, I'm willing to act as co-maintainer of
for the SPI subsystem.

Here's what I'm thinking.  Right now all SPI patches are going through
the -mm tree and just adding to akpm's burden.  I'd be more than happy
to take over the task of actually collecting the acked patches into a
git tree, getting them some exposure on linux-next, and asking Linus
to pull it during the merge window.  If you ack them, then I'll merge
them.

I'm also be willing to take responsibility for all powerpc-specific
SPI patches so that you don't need to look at them.

How does this sound to you?

Cheers,
g.

 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a1a2ace..2b697cb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4937,6 +4937,7 @@ F:	drivers/char/specialix*
 
 SPI SUBSYSTEM
 M:	David Brownell <dbrownell@users.sourceforge.net>
+M:	Grant Likely <grant.likely@secretlab.ca>
 L:	spi-devel-general@lists.sourceforge.net
 S:	Maintained
 F:	Documentation/spi/

