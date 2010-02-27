Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968671Ab0B0REV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 12:04:21 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030333Ab0B0QyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:54:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=WZiQGY9cnVK4pL9xWqI7LJobdo+RtYTYSayoM7QoMfzcXQxGxesz9pz3eEA80EOSo8
         kYd7iYzWrhBXKQOOqWUjgRSsk5bSqO7va8pxYSEXgEyjhTOs07LAw9ZPRT0Q7oAdA5JQ
         S1q+pOmFjWc4QlHwS2xZL4vnri+7GaFL6RvSg=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH 21/66] arch/um/include/shared/sigio.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:02 +0100
Message-Id: <1267289508-31031-22-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/um/include/shared/sigio.h:1: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/um/include/shared/sigio.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/include/shared/sigio.h b/arch/um/include/shared/sigio.h
index 434f1a9..8af4c67 100644
--- a/arch/um/include/shared/sigio.h
+++ b/arch/um/include/shared/sigio.h
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
  * Licensed under the GPL
  */
-- 
1.7.0.90.g251a4

