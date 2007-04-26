Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbXDZGHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbXDZGHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbXDZGHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:07:39 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:60385 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932932AbXDZGHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:07:38 -0400
Date: Thu, 26 Apr 2007 02:07:36 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@redhat.com>
Subject: [PATCH 05/12] MAINTAINERS: update selinux entry
In-Reply-To: <Line.LNX.4.64.0704260200450.30059@d.namei>
Message-ID: <Line.LNX.4.64.0704260206300.30059@d.namei>
References: <Line.LNX.4.64.0704260200450.30059@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Smalley <sds@tycho.nsa.gov>

Add Eric Paris as an SELinux maintainer.

Signed-off-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: James Morris <jmorris@namei.org>
---
 MAINTAINERS |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 277877a..4d487c3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2961,8 +2961,10 @@ P:	Stephen Smalley
 M:	sds@tycho.nsa.gov
 P:	James Morris
 M:	jmorris@namei.org
+P:	Eric Paris
+M:	eparis@parisplace.org
 L:	linux-kernel@vger.kernel.org (kernel issues)
-L: 	selinux@tycho.nsa.gov (general discussion)
+L: 	selinux@tycho.nsa.gov (subscribers-only, general discussion)
 W:	http://www.nsa.gov/selinux
 S:	Supported
 
-- 
1.5.0.6

