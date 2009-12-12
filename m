Return-Path: <linux-kernel-owner+w=401wt.eu-S933069AbZLMBSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069AbZLMBSi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932980AbZLMBSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:18:37 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:52254 "HELO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932975AbZLMBSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:18:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=G8IUT7OWkowFPPKbHsQnsLQ1PcFy4cYmv+kSRafu3U8CLrtczi2O0p4bxsDnFWQ1AN
         cwHG+GNrW4AiYYIxWTIXfJIXSg3Rubf0BFFJimSNAbmMagj8lSMigVZUDPTHJyry4HAp
         VzRszgwSpBqS5V7kMsfeUUv9QzlxHvUUgq22A=
MIME-Version: 1.0
Date: Sat, 12 Dec 2009 11:04:25 -0500
Message-ID: <2e3fcd490912120804x63417289j3e716f0c262d7b80@mail.gmail.com>
Subject: 
From: T Dent <tdent48227@gmail.com>
To: rdunlap@xenotime.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed typo in Documentation/CodingStyle

>From 47b08656a62b00b36c24315c63f2d48f70037de3 Mon Sep 17 00:00:00 2001
From: Tracey Dent <Tdent48227@gmail.com>
Date: Sat, 12 Dec 2009 10:16:18 -0500
Subject: [PATCH] trival: fix typo akin/asking for documentation


Signed-off-by: Tracey Dent <Tdent48227@gmail.com>
---
 Documentation/CodingStyle |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 8bb3723..e7c60be 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -17,7 +17,7 @@ Anyway, here goes:

 Tabs are 8 characters, and thus indentations are also 8 characters.
 There are heretic movements that try to make indentations 4 (or even 2!)
-characters deep, and that is akin to trying to define the value of PI to
+characters deep, and that is asking to trying to define the value of PI to
 be 3.

 Rationale: The whole idea behind indentation is to clearly define where
-- 
1.6.5.4
