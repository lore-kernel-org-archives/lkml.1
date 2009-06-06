Return-Path: <linux-kernel-owner+w=401wt.eu-S1753178AbZFFIcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbZFFIcr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 04:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbZFFIcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 04:32:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:58848 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbZFFIcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 04:32:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,315,1241420400"; 
   d="scan'208";a="697013662"
From: "Gao, Yunpeng" <yunpeng.gao@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 6 Jun 2009 16:35:15 +0800
Subject: RE: linux-next: Tree for June 3 (staging)
Thread-Topic: linux-next: Tree for June 3 (staging)
Thread-Index: AcnmGjDYTH8/QzRFTTWW0zj8pw1eEwAZqdlw
Message-ID: <38D9F46DFF92C54980D2F2C1E8EE313001A45F4CAA@pdsmsx503.ccr.corp.intel.com>
References: <20090603190952.2dd0cc70.sfr@canb.auug.org.au>
	<20090603231152.GA18701@suse.de>	<20090604232610.GA16053@intel.com>
	<200906052045.49610.bzolnier@gmail.com>
 <20090605211520.5846fbb8@lxorguk.ukuu.org.uk>
In-Reply-To: <20090605211520.5846fbb8@lxorguk.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n568XL54010855




>-----Original Message-----
>From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
>Sent: 2009Äê6ÔÂ6ÈÕ 4:15
>To: Bartlomiej Zolnierkiewicz
>Cc: Gao, Yunpeng; Greg KH; linux-kernel@vger.kernel.org
>Subject: Re: linux-next: Tree for June 3 (staging)
>
>> > +menuconfig MRST_NAND
>> > +	tristate "Moorestown NAND Flash controller"
>> > +	depends on BLOCK
>> > +	default m
>>
>> New drivers shouldn't be enabled by default.
>
>I think that rather depends on the driver - in this case I'd tend to
>agree as its not a common standard PC driver.

Thanks to Alan and Bartlomiej. I'll fix it to 'default n' and submit patches.

Thanks.

Rgds,
Yunpeng
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
