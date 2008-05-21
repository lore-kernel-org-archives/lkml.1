Return-Path: <linux-kernel-owner+w=401wt.eu-S1763439AbYEUITQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763439AbYEUITQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 04:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbYEUISx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 04:18:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbYEUISw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 04:18:52 -0400
From: Karel Zak <kzak@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, util-linux-ng@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Karel Zak <kzak@redhat.com>
Subject: [PATCH] MAINTAINERS: Add util-lilnux-ng package
Date: Wed, 21 May 2008 10:18:16 +0200
Message-Id: <1211357896-27067-1-git-send-email-kzak@redhat.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: 20080520191704.ea856364.akpm@linux-foundation.org
References: 20080520191704.ea856364.akpm@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 07:17:04PM -0700, Andrew Morton wrote:
> I think it would be useful to have a util-linux mention in the kernel's
> ./MAINTAINERS.  We're rather joined-at-the-hip and you guys are a bit
> hard to find.  If agreeable, please send a patch.

Signed-off-by: Karel Zak <kzak@redhat.com>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b42dcfc..8779b53 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4361,6 +4361,14 @@ M:	gregkh@suse.de
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
+UTIL-LINUX-NG PACKAGE
+P:	Karel Zak
+M:	kzak@redhat.com
+L:	util-linux-ng@vger.kernel.org
+W:	http://kernel.org/~kzak/util-linux-ng/
+T:	git://git.kernel.org/pub/scm/utils/util-linux-ng/util-linux-ng.git
+S:	Maintained
+
 VFAT/FAT/MSDOS FILESYSTEM:
 P:	OGAWA Hirofumi
 M:	hirofumi@mail.parknet.co.jp
-- 
1.5.4.1

