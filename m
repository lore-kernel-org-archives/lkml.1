Return-Path: <linux-kernel-owner+w=401wt.eu-S1757437AbYJVReP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbYJVReP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbYJVRcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:32:51 -0400
Received: from kroah.org ([198.145.64.141]:53009 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752497AbYJVRct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:32:49 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Machek <pavel@suse.cz>
Subject: [PATCH 04/42] Staging: document 4k stack problem for winbond driver
Date: Wed, 22 Oct 2008 10:28:45 -0700
Message-Id: <1224696563-5170-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081022172203.GA4000@kroah.com>
References: <20081022172203.GA4000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As noticed by Arjan

Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/winbond/README |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/winbond/README b/drivers/staging/winbond/README
index 707b6b3..cb944e4 100644
--- a/drivers/staging/winbond/README
+++ b/drivers/staging/winbond/README
@@ -5,6 +5,7 @@ TODO:
 	- remove typedefs
 	- remove unused ioctls
 	- use cfg80211 for regulatory stuff
+	- fix 4k stack problems
 
 Please send patches to Greg Kroah-Hartman <greg@kroah.com> and
 Pavel Machek <pavel@suse.cz>
-- 
1.6.0.2

