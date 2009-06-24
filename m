Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbZFXHei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbZFXHei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbZFXHea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:34:30 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:49715 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbZFXHea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:34:30 -0400
Date: Wed, 24 Jun 2009 09:33:19 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
       linux-cris-kernel@axis.com
Subject: [PATCH] MAINTAINERS: Change mailing list info for CRIS
Message-ID: <20090624073319.GK12383@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Posting to the dev-etrax mailing list is only allowed for subscribers,
and the list is more geared toward user applications than kernel developers.
Change to newly created mailing list for CRIS.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 02f6f78..2aff4ac 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1636,7 +1636,7 @@ P:	Mikael Starvik
 M:	starvik@axis.com
 P:	Jesper Nilsson
 M:	jesper.nilsson@axis.com
-L:	dev-etrax@axis.com
+L:	linux-cris-kernel@axis.com
 W:	http://developer.axis.com
 S:	Maintained
 F:	arch/cris/
-- 
1.6.1

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
