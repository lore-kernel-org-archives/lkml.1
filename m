Return-Path: <linux-kernel-owner+w=401wt.eu-S1754414AbZDQTj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbZDQTj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbZDQTjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:39:20 -0400
Received: from waste.org ([66.93.16.53]:43424 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbZDQTjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:39:20 -0400
Subject: [PATCH] Add myself to embedded maintainers
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linux Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 14:37:08 -0500
Message-Id: <1239997028.3307.496.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: make more work for myself

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r 8e0f1cee0a71 MAINTAINERS
--- a/MAINTAINERS	Sat Jan 24 15:41:13 2009 -0600
+++ b/MAINTAINERS	Fri Apr 17 14:12:07 2009 -0500
@@ -1627,6 +1627,8 @@
 EMBEDDED LINUX
 P:	Paul Gortmaker
 M:	paul.gortmaker@windriver.com
+P:	Matt Mackall
+M:	mpm@selenic.com
 P:	David Woodhouse
 M:	dwmw2@infradead.org
 L:	linux-embedded@vger.kernel.org


-- 
http://selenic.com : development and support for Mercurial and Linux


