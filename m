Return-Path: <linux-kernel-owner+w=401wt.eu-S933304AbXDZH0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304AbXDZH0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933340AbXDZH0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:26:43 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:42975 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933304AbXDZH0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:26:42 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-kernel@vger.kernel.org
Subject: [DOC] Fix wrong identifier name in Documentation/driver-model/devres.txt
Date: Thu, 26 Apr 2007 09:26:33 +0200
User-Agent: KMail/1.9.6
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704260926.33826.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Above and below we talk about my_midlayer_create_something, I assume that is
also meant here.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

---
commit bb5f6ef5bbbdc0233690fe3ba6d5787a6aab9b33
tree cd948e03b4add89be6e648d31b7778c64a51e8d2
parent 64aa7c3136258d3abc76354b5f83b9a9575169c0
author Rolf Eike Beer <eike-kernel@sf-tec.de> Thu, 26 Apr 2007 09:23:39 +0200
committer Rolf Eike Beer <eike-kernel@sf-tec.de> Thu, 26 Apr 2007 09:23:39 +0200

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
 
