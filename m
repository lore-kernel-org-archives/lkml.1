Return-Path: <linux-kernel-owner+w=401wt.eu-S1753051AbZGWGZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbZGWGZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 02:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZGWGZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 02:25:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752747AbZGWGZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 02:25:51 -0400
Date: Wed, 22 Jul 2009 23:22:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>, Pierre Ossman <pierre@ossman.eu>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       nico@cam.org, nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com,
       tony@atomide.com, david-b@pacbell.net, manuel.lauss@gmail.com,
       mirq-linux@rere.qmqm.pl, ppisa@pikron.com, jarkko.lavinen@nokia.com,
       ben@fluff.org, saschasommer@freenet.de, avorontsov@ru.mvista.com,
       oakad@yahoo.com, HaraldWelte@viatech.com, JosephChan@via.com.tw,
       adrian.hunter@nokia.com
Subject: Re: New MMC maintainer needed
Message-Id: <20090722232259.d0ff3495.akpm@linux-foundation.org>
In-Reply-To: <20090723055447.GA12211@console-pimps.org>
References: <20090714153601.6dfe70ff@mjolnir.ossman.eu>
	<20090722151744.fffd7bf5.akpm@linux-foundation.org>
	<4A67A9E8.5080002@mnementh.co.uk>
	<20090723055447.GA12211@console-pimps.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009 06:54:47 +0100 Matt Fleming <matt@console-pimps.org> wrote:

> On Thu, Jul 23, 2009 at 01:08:08AM +0100, Ian Molton wrote:
> > Andrew Morton wrote:
> >
> >> Until and unless someone else steps up I can act as maintainer of last
> >> resort for MMC.  As I'm presently doing for fbdev, hwmon, rtc, spi,
> >> gpio, i2o and about 1000 other identifiable subsystems.
> >
> > If no-one else is helping out, Im happy to also be CC'd on MMC patches.
> >
> 
> Ditto.

Thanks, guys.

I actually already have a little pile of MMC things queued:

http://userweb.kernel.org/~akpm/mmotm/broken-out/mmc-in-mmc_power_up-use-previously-selected-ocr-if-available.patch
http://userweb.kernel.org/~akpm/mmotm/broken-out/omap-hsmmc-do-not-enable-buffer-ready-interrupt-if-using-dma.patch
http://userweb.kernel.org/~akpm/mmotm/broken-out/mmc-msm_sdccc-driver-for-htc-dream.patch
http://userweb.kernel.org/~akpm/mmotm/broken-out/msm_sdccc-convert-printkkern_level-to-pr_level.patch
http://userweb.kernel.org/~akpm/mmotm/broken-out/msm_sdccc-stylistic-cleaning.patch
http://userweb.kernel.org/~akpm/mmotm/broken-out/msm_sdccc-move-overly-indented-code-to-separate-function.patch

I guess we own them now ;)
