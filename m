Return-Path: <linux-kernel-owner+w=401wt.eu-S1767320AbXECCOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767320AbXECCOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 22:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767324AbXECCOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 22:14:18 -0400
Received: from ns2.suse.de ([195.135.220.15]:47165 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767320AbXECCOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 22:14:11 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>, Tejun Heo <htejun@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/5] DOC: Fix wrong identifier name in Documentation/driver-model/devres.txt
Date: Wed,  2 May 2007 19:11:31 -0700
Message-Id: <11781583073805-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11781583003703-git-send-email-gregkh@suse.de>
References: <20070503020924.GB21316@kroah.com>
 <11781582932668-git-send-email-gregkh@suse.de>
 <11781583003703-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rolf Eike Beer <eike-kernel@sf-tec.de>

Above and below we talk about my_midlayer_create_something, I assume that is
also meant here.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/driver-model/devres.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 5163b85..6c8d8f2 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -182,7 +182,7 @@ For example, you can do something like the following.
 
 	...
 
-	devres_close_group(dev, my_midlayer_something);
+	devres_close_group(dev, my_midlayer_create_something);
 	return 0;
   }
 
-- 
1.5.1.2

