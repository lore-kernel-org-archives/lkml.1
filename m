Return-Path: <linux-kernel-owner+w=401wt.eu-S936170AbXHHQau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936170AbXHHQau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936190AbXHHQ2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:28:45 -0400
Received: from lazybastard.de ([212.112.238.170]:54604 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936318AbXHHQ2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:28:43 -0400
Date: Wed, 8 Aug 2007 18:24:47 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [Patch 18/18] include/linux/Kbuild
Message-ID: <20070808162447.GT15319@lazybastard.org>
References: <20070808161234.GB15319@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070808161234.GB15319@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-2.6.21logfs/include/linux/Kbuild~logfs	2007-08-08 02:57:37.000000000 +0200
+++ linux-2.6.21logfs/include/linux/Kbuild	2007-08-08 02:57:37.000000000 +0200
@@ -101,6 +101,7 @@ header-y += jffs2.h
 header-y += keyctl.h
 header-y += limits.h
 header-y += lock_dlm_plock.h
+header-y += logfs.h
 header-y += magic.h
 header-y += major.h
 header-y += matroxfb.h
