Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030391Ab0B0QzM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:55:12 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030357Ab0B0Qy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:54:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=gRzLCHJsB2e/tOM7FetAUAQk1z3zabugkZ3JWTG7V2HXNCqu9lgNxZqyJCWR5kgv9K
         fjmYtk9RHOjTAN/KZS5i72p+3apX/wK/3hajCcPX49imQsz/mNX5MSRh8fdI72iFR3Qk
         4aDabUanWD4Ni+8bCQd5pPKaUIMQ6pxhrOXew=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 31/66] include/linux/tc_act/tc_defact.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:12 +0100
Message-Id: <1267289508-31031-32-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/tc_act/tc_defact.h:9: ERROR: trailing whitespace
include/linux/tc_act/tc_defact.h:9: ERROR: code indent should use tabs where possible

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 include/linux/tc_act/tc_defact.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/tc_act/tc_defact.h b/include/linux/tc_act/tc_defact.h
index 6f65d07..17dddb4 100644
--- a/include/linux/tc_act/tc_defact.h
+++ b/include/linux/tc_act/tc_defact.h
@@ -6,7 +6,7 @@
 struct tc_defact {
 	tc_gen;
 };
-                                                                                
+
 enum {
 	TCA_DEF_UNSPEC,
 	TCA_DEF_TM,
-- 
1.7.0.90.g251a4

