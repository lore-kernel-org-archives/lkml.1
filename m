Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966190Ab0BZVbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 16:31:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:52696 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966162Ab0BZVbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 16:31:41 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: greg@kroah.com, michaelc@cs.wisc.edu, pjones@redhat.com,
       Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [PATCH 2/2] ibft: Update MAINTAINERS file.
Date: Fri, 26 Feb 2010 21:27:09 +0000
Message-Id: <1267219629-31536-3-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267219629-31536-1-git-send-email-konrad@kernel.org>
References: <1267219629-31536-1-git-send-email-konrad@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 21:30:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide the right e-mail and names for me and Peter.

Signed-off-by: Konrad Rzeszutek Wilk <konrad@kernel.org>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 317ed38..0d8a948 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2399,6 +2399,12 @@ L:	virtualization@lists.linux-foundation.org
 S:	Maintained
 F:	drivers/char/virtio_console.c
 
+iSCSI BOOT FIRMWARE TABLE (iBFT) DRIVER
+M:	Peter Jones <pjones@redhat.com>
+M:	Konrad Rzeszutek Wilk <konrad@kernel.org>
+S:	Maintained
+F:	drivers/firmware/iscsi_ibft*
+
 GSPCA FINEPIX SUBDRIVER
 M:	Frank Zago <frank@zago.net>
 L:	linux-media@vger.kernel.org
-- 
1.7.0

