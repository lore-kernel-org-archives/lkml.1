Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404Ab0AGWR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab0AGWR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 17:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246Ab0AGWR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 17:17:56 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55730 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab0AGWR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 17:17:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=SJ6t2F4e8zyKsGX2qeflEXNXw5mHA7csPXnLoUDLvEkTV74hFRdjHG0By/14J8xbcQ
         DoLGbmpVY7gFS/+kGnKgb9+fM0LsFzoCMflvowwRgbF1CnK4W+5th0ijlkdz8t5QhOi0
         0KoxcE58qo+uGW3r16urvSry0zZNOupKP19Fo=
Message-ID: <4B465DA1.6010300@googlemail.com>
Date: Thu, 07 Jan 2010 23:18:09 +0100
From: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: [PATCH]drivers/mtd/chips/cfi_probe.c:18 remove unneeded comment
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- ./drivers/mtd/chips/cfi_probe.c     2009-12-28 21:09:46.638828686 +0100
+++ ./drivers/mtd/chips/cfi_probe.c     2010-01-04 22:38:31.536678726 +0100
@@ -18,8 +18,6 @@
  #include <linux/mtd/cfi.h>
  #include <linux/mtd/gen_probe.h>

-//#define DEBUG_CFI
-
  #ifdef DEBUG_CFI
  static void print_cfi_ident(struct cfi_ident *);
  #endif
