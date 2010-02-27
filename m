Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030447Ab0B0RCY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 12:02:24 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968660Ab0B0Qzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:55:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=UqKkwoc8fDg53Lc7ug7T5E6nhhPQ0pQjTThrD1I8zyoJnR+os681H/hKs0DD+XMk1u
         nVptV8kdTqvDQZc8PvxUqjH8Wwy1VBoS3uCeu/M5TilMMz86gaTiulYQy2VZ5T/+PXHn
         JcG3yLqA26nQ/fowP2IC7gt7lDFciL0rPRgYk=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 37/66] include/linux/tc_act/tc_ipt.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:18 +0100
Message-Id: <1267289508-31031-38-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/tc_act/tc_ipt.h:19: ERROR: trailing whitespace
include/linux/tc_act/tc_ipt.h:19: ERROR: code indent should use tabs where possible

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 include/linux/tc_act/tc_ipt.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/tc_act/tc_ipt.h b/include/linux/tc_act/tc_ipt.h
index a233556..1140188 100644
--- a/include/linux/tc_act/tc_ipt.h
+++ b/include/linux/tc_act/tc_ipt.h
@@ -16,5 +16,4 @@ enum {
 	__TCA_IPT_MAX
 };
 #define TCA_IPT_MAX (__TCA_IPT_MAX - 1)
-                                                                                
 #endif
-- 
1.7.0.90.g251a4

