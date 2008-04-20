Return-Path: <linux-kernel-owner+w=401wt.eu-S1763009AbYDTKtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763009AbYDTKtV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbYDTKkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:40:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56348 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759590AbYDTKkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:40:52 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 27/36] PM: Remove legacy PM (fix)
Date: Sun, 20 Apr 2008 03:45:57 -0700
Message-Id: <1208688366-9252-27-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080420104516.GA9225@suse.de>
References: <20080420104516.GA9225@suse.de>
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Source file was removed.  Need to remove docbook reference also.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/DocBook/kernel-api.tmpl |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/Documentation/DocBook/kernel-api.tmpl b/Documentation/DocBook/kernel-api.tmpl
index dc0f30c..488dd4a 100644
--- a/Documentation/DocBook/kernel-api.tmpl
+++ b/Documentation/DocBook/kernel-api.tmpl
@@ -297,11 +297,6 @@ X!Earch/x86/kernel/mca_32.c
 !Ikernel/acct.c
   </chapter>
 
-  <chapter id="pmfuncs">
-     <title>Power Management</title>
-!Ekernel/power/pm.c
-  </chapter>
-
   <chapter id="devdrivers">
      <title>Device drivers infrastructure</title>
      <sect1><title>Device Drivers Base</title>
-- 
1.5.4.5

