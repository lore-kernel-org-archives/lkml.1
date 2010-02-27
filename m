Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030543Ab0B0RAr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 12:00:47 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030378Ab0B0Q5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:57:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=GnFwQ5bZjTcvvpfdV4bvHGLEKhKOddcvIvXmb+JajJdTz8hMcIYCtvxffWRjo7v1Rl
         S7rsUMkYV0mkrpuRiMpaMueF2ZLo9m7u9WUu/05suO3iSj92PeWZ38pAftZ7n2zu56w1
         +f8GM1yR1khcW7XgDMEzSmue4iNNhRZ97s51w=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 51/66] drivers/isdn/i4l/isdn_concap.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:32 +0100
Message-Id: <1267289508-31031-52-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/isdn/i4l/isdn_concap.h:1: WARNING: CVS style keyword markers, these will _not_ be updated
drivers/isdn/i4l/isdn_concap.h:11: ERROR: "foo * bar" should be "foo *bar"
drivers/isdn/i4l/isdn_concap.h:11: ERROR: space prohibited after that open parenthesis '('
drivers/isdn/i4l/isdn_concap.h:11: ERROR: space prohibited before that close parenthesis ')'

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 drivers/isdn/i4l/isdn_concap.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_concap.h b/drivers/isdn/i4l/isdn_concap.h
index 6ac7e04..cd7e3ba 100644
--- a/drivers/isdn/i4l/isdn_concap.h
+++ b/drivers/isdn/i4l/isdn_concap.h
@@ -8,6 +8,4 @@
  */
 
 extern struct concap_device_ops isdn_concap_reliable_dl_dops;
-extern struct concap_proto * isdn_concap_new( int );
-
-
+extern struct concap_proto *isdn_concap_new(int);
-- 
1.7.0.90.g251a4

