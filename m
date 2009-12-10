Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbZLJMzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbZLJMzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 07:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbZLJMzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 07:55:43 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:54443 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbZLJMzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 07:55:43 -0500
Subject: [PATCH] Fix a typo in the vgaarbiter Documentation
From: Detlef Riekenberg <wine.dev@web.de>
To: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Tiago Vignatti <tiago.vignatti@nokia.com>
Content-Type: text/plain
Date: Thu, 10 Dec 2009 13:55:48 +0100
Message-Id: <1260449748.7265.7.camel@p4.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19Em260Q3Q131WnZekRoPnpbpV5OueOaiuOH4lX
	ZJPG3jm+i68GabH/wnpJE0CFLAMCScLPmeU+3ZdAn3scikqBUR
	bwyAakPmw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I detected a typo, while reading "Documentation/vgaarbiter.txt".

Please CC me on any reply. Thanks

-- 
By by ... Detlef



>From 84db53ffacb278312de6e374928247c360dcbced Mon Sep 17 00:00:00 2001
From: Detlef Riekenberg <wine.dev@web.de>
Date: Thu, 10 Dec 2009 13:39:15 +0100
Subject: [PATCH] Fix a typo in the vgaarbiter Documentation

Signed-off-by: Detlef Riekenberg <wine.dev@web.de>
---
 Documentation/vgaarbiter.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/vgaarbiter.txt b/Documentation/vgaarbiter.txt
index 987f9b0..43a9b06 100644
--- a/Documentation/vgaarbiter.txt
+++ b/Documentation/vgaarbiter.txt
@@ -103,7 +103,7 @@ I.2 libpciaccess
 ----------------
 
 To use the vga arbiter char device it was implemented an API inside the
-libpciaccess library. One fieldd was added to struct pci_device (each
device
+libpciaccess library. One field was added to struct pci_device (each
device
 on the system):
 
     /* the type of resource decoded by the device */
-- 
1.5.4.3




