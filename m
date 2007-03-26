Return-Path: <linux-kernel-owner+w=401wt.eu-S1751783AbXCZKMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbXCZKMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbXCZKL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:11:57 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:32657 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbXCZKLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:11:55 -0400
X-IronPort-AV: i="4.14,329,1170651600"; 
   d="scan'208"; a="25489808:sNHT19880259"
Subject: [PATCH -mm] Blackfin arch: add kdebug header file
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 26 Mar 2007 18:12:21 +0800
Message-Id: <1174903941.32691.72.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

This patch adds kdebug.h header file to blackfin architecture.

Signed-off-by: Bryan Wu <bryan.wu@analog.com> 
---

 include/asm-blackfin/kdebug.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/include/asm-blackfin/kdebug.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-blackfin/kdebug.h
@@ -0,0 +1 @@
+#include <asm-generic/kdebug.h>
_

Thanks,
-Bryan Wu
