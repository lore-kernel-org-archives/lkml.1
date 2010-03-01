Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab0CASzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:55:52 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:54188 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab0CASzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:55:50 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: platform-driver-x86@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] MAINTAINERS: Added git tree to X86 Platform Drivers
Date: Mon,  1 Mar 2010 15:55:25 -0300
Message-Id: <1267469725-10492-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Matthew Garrett <mjg@redhat.com>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f355d11..56a7c4d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6042,6 +6042,7 @@ F:	arch/x86/
 X86 PLATFORM DRIVERS
 M:	Matthew Garrett <mjg@redhat.com>
 L:	platform-driver-x86@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git
 S:	Maintained
 F:	drivers/platform/x86
 
-- 
1.6.6.1

