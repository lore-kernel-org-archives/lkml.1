Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbZKDBsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbZKDBsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 20:48:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbZKDBst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 20:48:49 -0500
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:52028
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753792AbZKDBss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 20:48:48 -0500
In-Reply-To: <200911030952.17483.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       liqin.gnu@gmail.com, liqin.chen@sunplusct.com
MIME-Version: 1.0
Subject: Re: [PATCH] asm-generic: Fix typo in asm-generic/unistd.h.
X-Mailer: Lotus Notes Release 7.0.3 September 26, 2007
Message-ID: <OFC90831A4.A99EC411-ON48257664.00080761-48257664.0009EC42@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Wed, 4 Nov 2009 09:47:59 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/11/04 ?? 09:48:00,
	Serialize complete at 2009/11/04 ?? 09:48:00
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nA41nC16016523

Arnd Bergmann <arnd@arndb.de> Ğ´ÓÚ 2009-11-03 16:52:17:

> Is there any reason to use glibc-2.5 though? The current release
> is 2.10.1, and the version you used is over three years old.

We found many stable toolchain use glibc-2.5. so we select it.
In fact, what we think first is to could used it in product¡£
Even linux kernel, in company we still use kernel-2.6.27 version.
 
> Do you have plans to merge your port into eglibc when it's done?
> 

We have not this plan now.

Liqin
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
