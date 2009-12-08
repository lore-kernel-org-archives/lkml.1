Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbZLHSeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbZLHSeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 13:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbZLHSeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 13:34:13 -0500
Received: from mail.perches.com ([173.55.12.10]:1073 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689AbZLHSeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 13:34:12 -0500
Subject: [PATCH] MAINTAINERS: Remove file pattern from KERNEL VIRTUAL
 MACHINE (KVM) FOR AMD-V
From: Joe Perches <joe@perches.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Dec 2009 10:34:18 -0800
Message-ID: <1260297258.27677.51.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6c8166a77c98f473eb91e96a61c3cf78ac617278 folded
this file away.

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index ea781c1..fda3eec 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3109,7 +3109,6 @@ L:	kvm@vger.kernel.org
 W:	http://kvm.qumranet.com
 S:	Supported
 F:	arch/x86/include/asm/svm.h
-F:	arch/x86/kvm/kvm_svm.h
 F:	arch/x86/kvm/svm.c
 
 KERNEL VIRTUAL MACHINE (KVM) FOR POWERPC


