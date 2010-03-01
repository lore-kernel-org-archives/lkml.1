Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab0CAPQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:16:44 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:60578 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab0CAPOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:14:15 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 26/26] w35und: Update README
Date: Mon,  1 Mar 2010 17:04:28 +0200
Message-Id: <1267455868-4533-26-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Typedefs are gone now so update the README file.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/README |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/winbond/README b/drivers/staging/winbond/README
index cb944e4..4b480df 100644
--- a/drivers/staging/winbond/README
+++ b/drivers/staging/winbond/README
@@ -2,7 +2,6 @@ TODO:
 	- sparse cleanups
 	- checkpatch cleanups
 	- kerneldoc cleanups
-	- remove typedefs
 	- remove unused ioctls
 	- use cfg80211 for regulatory stuff
 	- fix 4k stack problems
-- 
1.6.3.3

