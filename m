Return-Path: <linux-kernel-owner+w=401wt.eu-S1756561AbYBJDT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbYBJDT7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 22:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbYBJDTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 22:19:52 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:57442 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755443AbYBJDTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 22:19:51 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Update arch/x86/boot/.gitignore with new generated files
Date: Sun, 10 Feb 2008 05:18:08 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20080201.769323)
Cc: mingo@elte.hu, torvalds@linux-foundation.org, tglx@linutronix.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802100518.09952.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

Following patch update arch/x86/boot/.gitignore with new auto-generated files

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

 arch/x86/boot/.gitignore |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/boot/.gitignore b/arch/x86/boot/.gitignore
index 1846514..b1bdc4c 100644
--- a/arch/x86/boot/.gitignore
+++ b/arch/x86/boot/.gitignore
@@ -3,3 +3,5 @@ bzImage
 setup
 setup.bin
 setup.elf
+cpustr.h
+mkcpustr

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
