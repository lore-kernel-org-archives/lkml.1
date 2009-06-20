Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbZFTNAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbZFTNAs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 09:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbZFTNAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 09:00:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:53447 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbZFTNAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 09:00:40 -0400
Subject: [PATCH] gitignore usr/initramfs_data.cpio.bz2 and
 usr/initramfs_data.cpio.lzma
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 20 Jun 2009 18:30:08 +0530
Message-Id: <1245502808.3042.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


usr/initramfs_data.cpio.bz2 and usr/initramfs_data.cpio.lzma are binary files should be ignored

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 usr/.gitignore |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/usr/.gitignore b/usr/.gitignore
index 69b2e89..8e48117 100644
--- a/usr/.gitignore
+++ b/usr/.gitignore
@@ -4,5 +4,7 @@
 gen_init_cpio
 initramfs_data.cpio
 initramfs_data.cpio.gz
+initramfs_data.cpio.bz2
+initramfs_data.cpio.lzma
 initramfs_list
 include
-- 
1.6.0.6



