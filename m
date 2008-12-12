Return-Path: <linux-kernel-owner+w=401wt.eu-S1758256AbYLLFWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbYLLFWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 00:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757832AbYLLFVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 00:21:31 -0500
Received: from sh.osrg.net ([192.16.179.4]:37938 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757300AbYLLFV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 00:21:28 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH mmotm 5/5] nilfs2: add maintainer
Date: Fri, 12 Dec 2008 14:17:01 +0900
Message-Id: <1229059021-9538-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1229059021-9538-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1229059021-9538-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1229059021-9538-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1229059021-9538-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1229059021-9538-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1229059021-9538-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20050308(IM148)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 63d5587..2bf4e81 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3151,6 +3151,13 @@ M:	andi@lisas.de
 L:	netdev@vger.kernel.org
 S:	Maintained
 
+NILFS2 FILESYSTEM
+P:	KONISHI Ryusuke
+M:	konishi.ryusuke@lab.ntt.co.jp
+L:	users@nilfs.org
+W:	http://www.nilfs.org/en/
+S:	Supported
+
 NINJA SCSI-3 / NINJA SCSI-32Bi (16bit/CardBus) PCMCIA SCSI HOST ADAPTER DRIVER
 P:	YOKOTA Hiroshi
 M:	yokota@netlab.is.tsukuba.ac.jp
-- 
1.5.6.5

