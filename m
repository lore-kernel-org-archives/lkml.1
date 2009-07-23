Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbZGWHFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbZGWHFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 03:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZGWHFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 03:05:12 -0400
Received: from smtp.nokia.com ([192.100.122.230]:42061 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbZGWHFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 03:05:11 -0400
Message-ID: <4A680ADB.2040008@nokia.com>
Date: Thu, 23 Jul 2009 10:01:47 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Matt Fleming <matt@console-pimps.org>, Ian Molton <ian@mnementh.co.uk>,
       Pierre Ossman <pierre@ossman.eu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
       "nico@cam.org" <nico@cam.org>,
       "nicolas.ferre@rfo.atmel.com" <nicolas.ferre@rfo.atmel.com>,
       "hskinnemoen@atmel.com" <hskinnemoen@atmel.com>,
       "tony@atomide.com" <tony@atomide.com>,
       "david-b@pacbell.net" <david-b@pacbell.net>,
       "manuel.lauss@gmail.com" <manuel.lauss@gmail.com>,
       "mirq-linux@rere.qmqm.pl" <mirq-linux@rere.qmqm.pl>,
       "ppisa@pikron.com" <ppisa@pikron.com>,
       "Lavinen Jarkko (Nokia-D/Helsinki)" <jarkko.lavinen@nokia.com>,
       "ben@fluff.org" <ben@fluff.org>,
       "saschasommer@freenet.de" <saschasommer@freenet.de>,
       "avorontsov@ru.mvista.com" <avorontsov@ru.mvista.com>,
       "oakad@yahoo.com" <oakad@yahoo.com>,
       "HaraldWelte@viatech.com" <HaraldWelte@viatech.com>,
       "JosephChan@via.com.tw" <JosephChan@via.com.tw>
Subject: Re: New MMC maintainer needed
References: <20090714153601.6dfe70ff@mjolnir.ossman.eu>	<20090722151744.fffd7bf5.akpm@linux-foundation.org>	<4A67A9E8.5080002@mnementh.co.uk>	<20090723055447.GA12211@console-pimps.org> <20090722232259.d0ff3495.akpm@linux-foundation.org>
In-Reply-To: <20090722232259.d0ff3495.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jul 2009 07:01:12.0186 (UTC) FILETIME=[5CE80DA0:01CA0B63]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 23 Jul 2009 06:54:47 +0100 Matt Fleming <matt@console-pimps.org> wrote:
> 
>> On Thu, Jul 23, 2009 at 01:08:08AM +0100, Ian Molton wrote:
>>> Andrew Morton wrote:
>>>
>>>> Until and unless someone else steps up I can act as maintainer of last
>>>> resort for MMC.  As I'm presently doing for fbdev, hwmon, rtc, spi,
>>>> gpio, i2o and about 1000 other identifiable subsystems.
>>> If no-one else is helping out, Im happy to also be CC'd on MMC patches.
>>>
>> Ditto.
> 
> Thanks, guys.
> 
> I actually already have a little pile of MMC things queued:
> 
> http://userweb.kernel.org/~akpm/mmotm/broken-out/mmc-in-mmc_power_up-use-previously-selected-ocr-if-available.patch
> http://userweb.kernel.org/~akpm/mmotm/broken-out/omap-hsmmc-do-not-enable-buffer-ready-interrupt-if-using-dma.patch
> http://userweb.kernel.org/~akpm/mmotm/broken-out/mmc-msm_sdccc-driver-for-htc-dream.patch
> http://userweb.kernel.org/~akpm/mmotm/broken-out/msm_sdccc-convert-printkkern_level-to-pr_level.patch
> http://userweb.kernel.org/~akpm/mmotm/broken-out/msm_sdccc-stylistic-cleaning.patch
> http://userweb.kernel.org/~akpm/mmotm/broken-out/msm_sdccc-move-overly-indented-code-to-separate-function.patch
> 
> I guess we own them now ;)
> 

There are also 32 patches starting here:

http://marc.info/?l=linux-kernel&m=124722949501844&w=2

