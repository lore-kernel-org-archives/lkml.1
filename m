Return-Path: <linux-kernel-owner+w=401wt.eu-S1756640AbYEWThx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbYEWThx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 15:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbYEWTho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 15:37:44 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:36347 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbYEWThn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 15:37:43 -0400
Message-ID: <48371D04.9050906@ct.jp.nec.com>
Date: Fri, 23 May 2008 12:37:40 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: [PATCH -rt] gitignore Module.markers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 .gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/.gitignore b/.gitignore
index fdcce40..3d04ea7 100644
--- a/.gitignore
+++ b/.gitignore
@@ -28,6 +28,7 @@ vmlinux*
 !vmlinux.lds.S
 System.map
 Module.symvers
+Module.markers
 !.gitignore
 
 #
-- 
1.5.4.1

