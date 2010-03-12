Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933942Ab0CLRua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 12:50:30 -0500
Received: from p01c12o144.mxlogic.net ([208.65.145.67]:51826 "EHLO
	p01c12o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069Ab0CLRu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 12:50:28 -0500
X-MXL-Hash: 4b9a7ee463297113-2544e0fc12ea48825e67e766887d1732c7097e97
X-MXL-Hash: 4b9a7ed959cf6ff1-28cd99db39052cf49a0a84b6e6cb38b1f3198a36
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Richard Purdie <rpurdie@rpsys.net>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Fri, 12 Mar 2010 11:49:23 -0600
Subject: RE: [PATCH] backlight: provide sysfs percent brightness attribute
Thread-Topic: [PATCH] backlight: provide sysfs percent brightness attribute
Thread-Index: AcrCCxsHkseDWCqgSTa8suq/VtjpVQAARQQg
Message-ID: <0D753D10438DA54287A00B02708426976368437D29@AUSP01VMBX24.collaborationhost.net>
References: <0D753D10438DA54287A00B02708426976368437C8D@AUSP01VMBX24.collaborationhost.net>
	 <20100312173341.GA4931@khazad-dum.debian.net> <1268415585.1625.13.camel@rex>
In-Reply-To: <1268415585.1625.13.camel@rex>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010030401)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.97]
X-AnalysisOut: [v=1.0 c=1 a=mIFmv19T6S4A:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=qhvANl0glaz90f+3g7Keqg==:17 a=rKe7JGH92IMGE_6vFuMA]
X-AnalysisOut: [:9 a=4TkljBrFsjz_ovWTmcwUeUzgUSwA:4 a=QEXdDO2ut3YA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o2CHodmE012096

On Friday, March 12, 2010 10:40 AM, Richard Purdie wrote:
> On Fri, 2010-03-12 at 14:33 -0300, Henrique de Moraes Holschuh wrote:
>> On Fri, 12 Mar 2010, H Hartley Sweeten wrote:
>>> It's usually more convenient to set the backlight brightness
>>> as a 'percent' of total brightness rather than using the raw
>>> 'brightness' value.
>> 
>> Well, that scale is often not linear, so you are not dealing with fractions
>> of the effective brightness, just with fractions of an arbritary scale
>> exported by the backend driver.  Much of the "usefulness" of a "percent"
>> scale dies right there.
>
> This patch does nothing to address that though.
>
> I agree this is a userland issue and having two interfaces to the kernel
> to do the same thing is not a good idea in general.
>
> So no, I'm not going to take that patch, sorry.

OK.  Thank for your input.

Regards,
Hartleyÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
