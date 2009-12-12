Return-Path: <linux-kernel-owner+w=401wt.eu-S933369AbZLMBX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933369AbZLMBX7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933326AbZLMBX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:23:58 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:48357 "HELO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933327AbZLMBX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:23:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Zm9Z2mlw0/kkQoL13M2g4F3mjjxtEMq1gKl6zHUxvVUL/w09Dzy3AtX841LtAIpisc
         Pe98Nfb/X2+rZEfZekyllrBtdmtik0/G+x7XfhD/nqwhheXCYiDHnWWcuF35YXRNbqFf
         chiKnkkSRCgDcljja2xJy6wGrQsuHTBL1wSIA=
MIME-Version: 1.0
Date: Sat, 12 Dec 2009 11:07:51 -0500
Message-ID: <2e3fcd490912120807y335bd573u5126f9411edc918b@mail.gmail.com>
Subject: [PATCH] trival: fix typo akin/asking for documentation
From: T Dent <tdent48227@gmail.com>
To: rdunlap@xenotime.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: T Dent <tdent48227@gmail.com>
Date: Sat, 12 Dec 2009 11:04:25 -0500
Subject:
To: rdunlap@xenotime.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

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
