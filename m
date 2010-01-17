Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645Ab0AQUf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0AQUf2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 15:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632Ab0AQUfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 15:35:25 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:43059 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab0AQUfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 15:35:24 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-doc@vger.kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] doc: document nopat parameter
Date: Sun, 17 Jan 2010 18:32:49 -0200
Message-Id: <1263760370-7180-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 Documentation/kernel-parameters.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 736d456..a2e1712 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1729,6 +1729,8 @@ and is between 256 and 4096 characters. It is defined in the file
 	nomfgpt		[X86-32] Disable Multi-Function General Purpose
 			Timer usage (for AMD Geode machines).
 
+	nopat		[X86] Disable PAT support
+
 	norandmaps	Don't use address space randomization.  Equivalent to
 			echo 0 > /proc/sys/kernel/randomize_va_space
 
-- 
1.6.6

