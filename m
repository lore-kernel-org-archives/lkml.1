Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830Ab0ANHN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab0ANHN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 02:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242Ab0ANHNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 02:13:25 -0500
Received: from mail.perches.com ([173.55.12.10]:1162 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904Ab0ANHNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 02:13:24 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/24] MAINTAINERS: Document new "Q:" patchwork queue type
Date: Wed, 13 Jan 2010 23:13:00 -0800
Message-Id: <dad0b9fe4d42d6523c16edfc5275a01de1272fd4.1263452908.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1263452908.git.joe@perches.com>
References: <cover.1263452908.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b8852f8..8dd1fd0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -71,6 +71,7 @@ Descriptions of section entries:
 	M: Mail patches to: FullName <address@domain>
 	L: Mailing list that is relevant to this area
 	W: Web-page with status/info
+	Q: Patchwork web based patch tracking system site
 	T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit.
 	S: Status, one of the following:
 	   Supported:	Someone is actually paid to look after this.
-- 
1.6.6.rc0.57.gad7a

