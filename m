Return-Path: <linux-kernel-owner+w=401wt.eu-S1758258AbYEWTif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258AbYEWTif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 15:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757279AbYEWTiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 15:38:04 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:36366 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871AbYEWThs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 15:37:48 -0400
Message-ID: <48371D09.1050102@ct.jp.nec.com>
Date: Fri, 23 May 2008 12:37:45 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: [PATCH -rt] gitignore scripts/testlpp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 scripts/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/.gitignore b/scripts/.gitignore
index b939fbd..bb1dd86 100644
--- a/scripts/.gitignore
+++ b/scripts/.gitignore
@@ -7,3 +7,4 @@ pnmtologo
 bin2c
 unifdef
 binoffset
+testlpp
-- 
1.5.4.1

