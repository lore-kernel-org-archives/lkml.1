Return-Path: <linux-kernel-owner+w=401wt.eu-S1759744AbZDNSg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759744AbZDNSg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759665AbZDNSgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:36:42 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4455 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759642AbZDNSgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:36:41 -0400
Subject: [PATCH] MAINTAINERS - Update KMEMTRACE pattern after file rename
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 11:36:37 -0700
Message-Id: <1239734197.7994.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 5b4f1dd..d8fe7eb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3267,7 +3267,7 @@ P:	Eduard - Gabriel Munteanu
 M:	eduard.munteanu@linux360.ro
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
-F:	Documentation/vm/kmemtrace.txt
+F:	Documentation/trace/kmemtrace.txt
 F:	include/trace/kmemtrace.h
 F:	kernel/trace/kmemtrace.c
 


