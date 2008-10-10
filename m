Return-Path: <linux-kernel-owner+w=401wt.eu-S1763040AbYJJWqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763040AbYJJWqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 18:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbYJJWp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 18:45:59 -0400
Received: from kroah.org ([198.145.64.141]:39631 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753619AbYJJWp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 18:45:58 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/23] Staging: add MAINTAINERS entry
Date: Fri, 10 Oct 2008 15:42:28 -0700
Message-Id: <1223678567-30143-4-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081010224130.GA30117@kroah.com>
References: <20081010224130.GA30117@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

Someone has to claim this mess, might as well let everyone know who to
blame.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7a03bd5..ea6b478 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3863,6 +3863,13 @@ M:	chrisw@sous-sol.org
 L:	stable@kernel.org
 S:	Maintained
 
+STAGING SUBSYSTEM:
+P:	Greg Kroah-Hartman
+M:	gregkh@suse.de
+L:	linux-kernel@vger.kernel.org
+T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
+S:	Maintained
+
 SHARP LH SUPPORT (LH7952X & LH7A40X)
 P:	Marc Singer
 M:	elf@buici.com
-- 
1.6.0.2

