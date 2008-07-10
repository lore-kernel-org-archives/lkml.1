Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbYGJQkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbYGJQkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 12:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758440AbYGJQju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 12:39:50 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60459 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758450AbYGJQjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 12:39:49 -0400
Subject: [PATCH] arch/x86/kernel/.gitignore: Added vmlinux.lds to
	.gitignore file because it shouldn't be tracked.
From: Daniel Guilak <guilak@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, daniel@danielguilak.com
Content-Type: text/plain
Date: Thu, 10 Jul 2008 09:39:32 -0700
Message-Id: <1215707972.6497.4.camel@dguilak-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Guilak <daniel@danielguilak.com>
---
 arch/x86/kernel/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/.gitignore b/arch/x86/kernel/.gitignore
index 4ea38a3..08f4fd7 100644
--- a/arch/x86/kernel/.gitignore
+++ b/arch/x86/kernel/.gitignore
@@ -1,2 +1,3 @@
 vsyscall.lds
 vsyscall_32.lds
+vmlinux.lds
-- 
1.5.4.3


