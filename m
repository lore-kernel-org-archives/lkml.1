Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbZAHCLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbZAHCLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 21:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756572AbZAHCKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 21:10:33 -0500
Received: from adelie.canonical.com ([91.189.90.139]:43447 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964AbZAHCKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 21:10:30 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/3] sysrq documentation: remove the redundant updated date
Date: Thu,  8 Jan 2009 02:10:24 +0000
Message-Id: <1231380626-20597-2-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.0.4.911.gc990
In-Reply-To: <1231380626-20597-1-git-send-email-apw@canonical.com>
References: <1231380626-20597-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

git is maintaining the last update time much more accuratly than
the internal update time.  Remove it.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 Documentation/sysrq.txt |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/Documentation/sysrq.txt b/Documentation/sysrq.txt
index 10a0263..265f637 100644
--- a/Documentation/sysrq.txt
+++ b/Documentation/sysrq.txt
@@ -1,6 +1,5 @@
 Linux Magic System Request Key Hacks
 Documentation for sysrq.c
-Last update: 2007-AUG-04
 
 *  What is the magic SysRq key?
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 
1.6.0.4.911.gc990

