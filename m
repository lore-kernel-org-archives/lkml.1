Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbZIDBZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbZIDBZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 21:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbZIDBZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 21:25:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332AbZIDBZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 21:25:51 -0400
Date: Thu, 3 Sep 2009 21:25:35 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
       akpm@linux-foundation.org, Sam Ravnborg <sam@ravnborg.org>,
       Amerigo Wang <amwang@redhat.com>, linux-kbuild@vger.kernel.org
Message-Id: <20090904012803.3749.43930.sendpatchset@localhost.localdomain>
In-Reply-To: <20090904012755.3749.69645.sendpatchset@localhost.localdomain>
References: <20090904012755.3749.69645.sendpatchset@localhost.localdomain>
Subject: [Patch 1/5] gitignore: add .gcov files
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add *.gcov into .gitignore.

Signed-off-by: WANG Cong <amwang@redhat.com>

---
Index: linux-2.6/.gitignore
===================================================================
--- linux-2.6.orig/.gitignore
+++ linux-2.6/.gitignore
@@ -28,6 +28,7 @@
 *.lzma
 *.patch
 *.gcno
+*.gcov
 
 #
 # Top-level generic files
