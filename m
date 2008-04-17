Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbYDQJQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbYDQJQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763348AbYDQJLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:11 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:59016
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759415AbYDQJK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:10:58 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org,
       Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 14/45] KVM: s390: update maintainers
Date: Thu, 17 Apr 2008 12:10:19 +0300
Message-Id: <1208423450-29415-15-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

This patch adds an entry for kvm on s390 to the MAINTAINERS file :-). We intend
to push all patches regarding this via Avi's kvm.git.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 MAINTAINERS |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e467758..27e42b9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2311,6 +2311,16 @@ L:	kvm-ia64-devel@lists.sourceforge.net
 W:	kvm.sourceforge.net
 S:	Supported
 
+KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
+P:	Carsten Otte
+M:	cotte@de.ibm.com
+P:	Christian Borntraeger
+M:	borntraeger@de.ibm.com
+M:	linux390@de.ibm.com
+L:	linux-s390@vger.kernel.org
+W:	http://www.ibm.com/developerworks/linux/linux390/
+S:	Supported
+
 KEXEC
 P:	Eric Biederman
 M:	ebiederm@xmission.com
-- 
1.5.5

