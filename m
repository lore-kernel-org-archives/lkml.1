Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbYI1PxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbYI1PxM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbYI1Ppd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:45:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50864 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbYI1Ppb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:45:31 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 12/25] add MAINTAINERS entry for the KVM AMD module
Date: Sun, 28 Sep 2008 18:44:48 +0300
Message-Id: <1222616701-1206-13-git-send-email-avi@redhat.com>
In-Reply-To: <1222616701-1206-1-git-send-email-avi@redhat.com>
References: <1222616701-1206-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index cad81a2..232ff4a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2416,6 +2416,13 @@ L:	kvm@vger.kernel.org
 W:	http://kvm.qumranet.com
 S:	Supported
 
+KERNEL VIRTUAL MACHINE (KVM) FOR AMD-V
+P:	Joerg Roedel
+M:	joerg.roedel@amd.com
+L:	kvm@vger.kernel.org
+W:	http://kvm.qumranet.com
+S:	Supported
+
 KERNEL VIRTUAL MACHINE (KVM) FOR POWERPC
 P:	Hollis Blanchard
 M:	hollisb@us.ibm.com
-- 
1.6.0.1

