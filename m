Return-Path: <linux-kernel-owner+w=401wt.eu-S1765106AbZFQIlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765106AbZFQIlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 04:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756545AbZFQIlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 04:41:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:45604 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862AbZFQIlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 04:41:42 -0400
Subject: [PATCH] gitignore scripts/ihex2fw
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 14:11:57 +0530
Message-Id: <1245228117.2662.2.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


scripts/ihex2fw is a binary file is suitable candidate for ignore

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 .gitignore |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/.gitignore b/.gitignore
index cecb3b0..cdfb7ce 100644
--- a/.gitignore
+++ b/.gitignore
@@ -70,6 +70,9 @@ GRTAGS
 GSYMS
 GTAGS
 
+# scripts binary files
+scripts/ihex2fw
+
 *.orig
 *~
 \#*#
-- 
1.6.0.6



