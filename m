Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030407Ab0B0Qzo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:55:44 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030378Ab0B0Qzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:55:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ban+lyCMX1WJAikNwjG3IzEAzmfX6bODHAoQuUe6CbXBfpNE5d1NlGCHYwfoemGDYK
         5nTctkEqBWWIM04MtU2umzx6+S/L+lWwieHYevRc/9Ir1bOhThVTyFJKII52CekhzEnz
         /ZIq9ESPEE8qnklJLJFWYMpmbldu6nRzwjpwo=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org
Subject: [PATCH 38/66] sound/oss/coproc.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:19 +0100
Message-Id: <1267289508-31031-39-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sound/oss/coproc.h:7: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 sound/oss/coproc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/oss/coproc.h b/sound/oss/coproc.h
index 7306346..7bec21b 100644
--- a/sound/oss/coproc.h
+++ b/sound/oss/coproc.h
@@ -4,7 +4,7 @@
  */
 
 /*
- * Coprocessor access types 
+ * Coprocessor access types
  */
 #define COPR_CUSTOM		0x0001	/* Custom applications */
 #define COPR_MIDI		0x0002	/* MIDI (MPU-401) emulation */
-- 
1.7.0.90.g251a4

