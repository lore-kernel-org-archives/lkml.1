Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbZHHSWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbZHHSWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 14:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbZHHSWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 14:22:18 -0400
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:39998 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbZHHSWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 14:22:17 -0400
Date: Sat, 8 Aug 2009 10:39:00 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH] Documentation/vm/.gitignore: Add page-types
Message-ID: <20090808173900.GA21009@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-TUID: c3f1bbedcacb6041
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 Documentation/vm/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/vm/.gitignore b/Documentation/vm/.gitignore
index 33e8a02..09b164a 100644
--- a/Documentation/vm/.gitignore
+++ b/Documentation/vm/.gitignore
@@ -1 +1,2 @@
+page-types
 slabinfo
-- 
1.5.6.5

