Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968647Ab0B0Qzw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:55:52 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030402Ab0B0Qzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:55:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=NXEKfhCKvxhVv0uqNgv7CphtdRG8pz5Ee5KHUoEmzXH1Sb2cSrVHCmEa9bE8n7LX5l
         4uHP0t5MMDTqyBy5o5SYQJQqHdQXQ3tnFTcztR7Xl1pFBLxcibyyxDuMC2zKs4AJUl3q
         0k5R9YOwgr7WzgJY8Do7FCP363nCnsA29yoiA=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH 39/66] arch/um/drivers/pcap_user.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:20 +0100
Message-Id: <1267289508-31031-40-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/um/drivers/pcap_user.h:1: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/um/drivers/pcap_user.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/pcap_user.h b/arch/um/drivers/pcap_user.h
index d8ba615..6ff1c46 100644
--- a/arch/um/drivers/pcap_user.h
+++ b/arch/um/drivers/pcap_user.h
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
  * Licensed under the GPL
  */
@@ -18,4 +18,3 @@ struct pcap_data {
 extern const struct net_user_info pcap_user_info;
 
 extern int pcap_user_read(int fd, void *buf, int len, struct pcap_data *pri);
-
-- 
1.7.0.90.g251a4

