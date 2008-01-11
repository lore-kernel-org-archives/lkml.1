Return-Path: <linux-kernel-owner+w=401wt.eu-S1762881AbYAKWSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762881AbYAKWSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 17:18:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761597AbYAKWRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 17:17:54 -0500
Received: from mail.fieldses.org ([66.93.2.214]:59362 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760539AbYAKWRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 17:17:54 -0500
Date: Fri, 11 Jan 2008 17:17:49 -0500
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Documentation/ patches
Message-ID: <20080111221749.GN28043@fieldses.org>
References: <1200088216-9211-1-git-send-email-bfields@citi.umich.edu> <20080111140314.dd626be3.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111140314.dd626be3.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.17 (2007-12-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 02:03:14PM -0800, Randy Dunlap wrote:
> On Fri, 11 Jan 2008 16:50:12 -0500 J. Bruce Fields wrote:
> 
> > 
> > I've had these (fairly trivial) patches sitting around for a while just
> > because I had no idea who to send them to.
> > 
> > So I figure that means they, err, go to you?
> > 
> > Apologies if not.
> 
> All 4 Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Could we do something like this?

--b.

>From 05873d4263eb50ac3b7f1d32e9bc4ec3a74f65a0 Mon Sep 17 00:00:00 2001
From: J. Bruce Fields <bfields@citi.umich.edu>
Date: Fri, 11 Jan 2008 17:14:19 -0500
Subject: [PATCH] MAINTAINERS: Clarify scope of documentation maintainership

Randy Dunlap <randy.dunlap@oracle.com> appears to review any
documentation patches, not just those that raise Docbook issues.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 79c711e..2d10ca8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1306,7 +1306,7 @@ M:	juergh@gmail.com
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 
-DOCBOOK FOR DOCUMENTATION
+DOCUMENTATION
 P:	Randy Dunlap
 M:	rdunlap@xenotime.net
 S:	Maintained
-- 
1.5.4.rc2.60.gb2e62

