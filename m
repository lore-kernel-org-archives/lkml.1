Return-Path: <linux-kernel-owner+w=401wt.eu-S936215AbZDDAmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936215AbZDDAmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 20:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760093AbZDDAmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 20:42:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38959 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758963AbZDDAmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 20:42:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FS-Cache: Add MAINTAINERS record for FS-Cache and CacheFiles
To: torvalds@osdl.org, joe@perches.com
Cc: dhowells@redhat.com, steved@redhat.com, linux-cachefs@redhat.com,
       linux-kernel@vger.kernel.org
Date: Sat, 04 Apr 2009 01:40:56 +0100
Message-ID: <20090404004056.1473.94222.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MAINTAINERS record for FS-Cache and CacheFiles.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 MAINTAINERS |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)


diff --git a/MAINTAINERS b/MAINTAINERS
index 6fe6f39..e56f9f3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1068,6 +1068,14 @@ W:	http://linuxtv.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 
+CACHEFILES: FS-CACHE BACKEND FOR CACHING ON MOUNTED FILESYSTEMS
+P:	David Howells
+M:	dhowells@redhat.com
+L:	linux-cachefs@redhat.com
+S:	Supported
+F:	Documentation/filesystems/caching/cachefiles.txt
+F:	fs/cachefiles/
+
 CAFE CMOS INTEGRATED CAMERA CONTROLLER DRIVER
 P:	Jonathan Corbet
 M:	corbet@lwn.net
@@ -1873,6 +1881,15 @@ M:	rjw@sisk.pl
 L:	linux-pm@lists.linux-foundation.org
 S:	Supported
 
+FS-CACHE: LOCAL CACHING FOR NETWORK FILESYSTEMS
+P:	David Howells
+M:	dhowells@redhat.com
+L:	linux-cachefs@redhat.com
+S:	Supported
+F:	Documentation/filesystems/caching/
+F:	fs/fscache/
+F:	include/linux/fscache*.h
+
 FTRACE
 P:	Steven Rostedt
 M:	rostedt@goodmis.org

