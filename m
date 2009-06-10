Return-Path: <linux-kernel-owner+w=401wt.eu-S1760069AbZFJQac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760069AbZFJQac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 12:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754952AbZFJQaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 12:30:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55941 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbZFJQaY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 12:30:24 -0400
From: Arne Janbu <arnej@ampheus.de>
To: linux-kernel@vger.kernel.org
Subject: Ignore *.lzma files
Date: Wed, 10 Jun 2009 18:25:10 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-rc8-zen0; KDE/4.2.88; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <200906101825.10474.arnej@ampheus.de>
X-Provags-ID: V01U2FsdGVkX1+Db6TNbw4ToLqGsI8UDBsy9p6G338TjWY5MVW
 kNTObVyNXMXdrsjAKZnyi42n4e8flEMLn5/immMGbYzA0xv62V
 i6HtOhfQcUMSjGg77JHSNHOCy8+eUDc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 71cc682035dacd31b11666edf910afb6a4201da4 Mon Sep 17 
00:00:00 2001
From: Arne Janbu <arnej@ampheus.de>
Date: Wed, 10 Jun 2009 17:16:42 +0200
Subject: [PATCH] Add *.lzma to .gitignore

---
 .gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/.gitignore b/.gitignore
index 51bd99d..faa8b4d 100644
--- a/.gitignore
+++ b/.gitignore
@@ -25,6 +25,7 @@
 *.elf
 *.bin
 *.gz
+*.lzma
 
 #
 # Top-level generic files
-- 
1.6.3.2
