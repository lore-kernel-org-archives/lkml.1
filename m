Return-Path: <linux-kernel-owner+w=401wt.eu-S1757059AbYACRgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbYACRgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbYACRgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:36:35 -0500
Received: from mail.atmel.fr ([81.80.104.162]:49946 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbYACRge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:36:34 -0500
Message-ID: <477D1D15.8080700@atmel.com>
Date: Thu, 03 Jan 2008 18:36:21 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] MAINTAINERS: email update and add missing entry
References: <477D01FC.8060009@atmel.com>
In-Reply-To: <477D01FC.8060009@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAINTAINERS email update
add atmel_lcdfb entry

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Resent because of a patch whitespace formatting issue.

MAINTAINERS |    8 +++++++-
===================================================================
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -665,12 +665,18 @@

  ATMEL AT91 MCI DRIVER
  P:	Nicolas Ferre
-M:	nicolas.ferre@rfo.atmel.com
+M:	nicolas.ferre@atmel.com
  L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
  W:	http://www.atmel.com/products/AT91/
  W:	http://www.at91.com/
  S:	Maintained

+ATMEL LCDFB DRIVER
+P:	Nicolas Ferre
+M:	nicolas.ferre@atmel.com
+L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+S:	Maintained
+
  ATMEL MACB ETHERNET DRIVER
  P:	Haavard Skinnemoen
  M:	hskinnemoen@atmel.com

