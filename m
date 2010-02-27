Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030555Ab0B0RAX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 12:00:23 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030319Ab0B0Q5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:57:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=IUoXxeYR2oStTqXzBZiqmTCrVjFyuX1fh8ifI8MsYtK+l7HK0nMDXXIiEBopb0O0QA
         SsEUBpNYIlgyTUnh7DJBnHAo72QqNROiCW2uMWhrIdVVRZo9RZck9zr0MN+oR3R58U4E
         ZynijRn8mFsUvRNUiN8LADbazuJBrfSTHYI40=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org
Subject: [PATCH 53/66] drivers/s390/cio/blacklist.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:34 +0100
Message-Id: <1267289508-31031-54-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/s390/cio/blacklist.h:4: WARNING: space prohibited between function name and open parenthesis '('

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 drivers/s390/cio/blacklist.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/s390/cio/blacklist.h b/drivers/s390/cio/blacklist.h
index 95e25c1..4a78e64 100644
--- a/drivers/s390/cio/blacklist.h
+++ b/drivers/s390/cio/blacklist.h
@@ -1,6 +1,6 @@
 #ifndef S390_BLACKLIST_H
 #define S390_BLACKLIST_H
 
-extern int is_blacklisted (int ssid, int devno);
+extern int is_blacklisted(int ssid, int devno);
 
 #endif
-- 
1.7.0.90.g251a4

