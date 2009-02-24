Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbZBXDoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbZBXDoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 22:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbZBXDoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 22:44:46 -0500
Received: from exchtp08.via.com.tw ([61.66.243.7]:36025 "EHLO
	exchtp08.via.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbZBXDop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 22:44:45 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: mmotm 2009-02-20-15-52 uploaded (via-sdmmc)
Date: Tue, 24 Feb 2009 11:44:35 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB808AFECA1@exchtp03.taipei.via.com.tw>
In-Reply-To: <499F869C.9000208@oracle.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: mmotm 2009-02-20-15-52 uploaded (via-sdmmc)
Thread-Index: AcmT3x++xOik6NM9SLK1/HNbrlCT7gCUmXPA
From: <JosephChan@via.com.tw>
To: <randy.dunlap@oracle.com>, <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 24 Feb 2009 03:44:36.0283 (UTC) FILETIME=[367358B0:01C99632]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n1O3j3wM029215

Randy,

Weâ€™ve fixed this is v5 patch. Thanks.
I will send out  this patch later.


Andrew,

Any comment on this? Should I send the whole v5 patch to linux-kernel mail-list? Or just patch for this issue? Thanks.

BRs,
Joseph

> -----Original Message-----
> From: Randy Dunlap [mailto:randy.dunlap@oracle.com] 
> Sent: Saturday, February 21, 2009 12:44 PM
> To: linux-kernel@vger.kernel.org
> Cc: Andrew Morton; Joseph Chan
> Subject: Re: mmotm 2009-02-20-15-52 uploaded (via-sdmmc)
> 
> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-02-20-15-52 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> > 
> > It contains the following patches against 2.6.29-rc5:
> > 
> 
> > via-sdmmc-via-msp-card-reader-driver-support.patch
> 
> 
> when CONFIG_PM=n:
> 
> drivers/mmc/host/via-sdmmc.c:336: error: 'struct 
> via_crdr_chip' has no member named 'pm_pcictrl_reg'
> drivers/mmc/host/via-sdmmc.c:355: error: 'struct 
> via_crdr_chip' has no member named 'pm_pcictrl_reg'
> drivers/mmc/host/via-sdmmc.c:372: error: 'struct 
> via_crdr_chip' has no member named 'pm_sdhc_reg'
> drivers/mmc/host/via-sdmmc.c:392: error: 'struct 
> via_crdr_chip' has no member named 'pm_sdhc_reg'
> 
> --
> ~Randy
> 
> 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
