Return-Path: <linux-kernel-owner+w=401wt.eu-S967030AbZLIArN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967030AbZLIArN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 19:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967004AbZLIArM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 19:47:12 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:43236 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966998AbZLIArL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 19:47:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=O7SgI8Eh75su30R9J0ftWjBUXeZ6WvcTmfWyWsG3rx0lDdJecGextitJqwULrYObgf
         EZnB3l59VmO1YvFOJbuy3L+ukMqk4MdoezBWEBm66+6NN8KaWthEiYB0Zbc0E8WkYsH4
         gFH4qyu2h9mv4eRAulxvMm3tD2/s/Xhcj0Nr0=
MIME-Version: 1.0
In-Reply-To: <fa686aa40912081625y3750a7fegbac38926182e38c6@mail.gmail.com>
References: <20091208211258.GA13706@pengutronix.de>
	 <20091208153239.af0b5bb8.akpm@linux-foundation.org>
	 <fa686aa40912081625y3750a7fegbac38926182e38c6@mail.gmail.com>
Date: Wed, 9 Dec 2009 09:47:17 +0900
Message-ID: <1b68c6790912081647p39f0b285q2c164ab41c673aeb@mail.gmail.com>
Subject: Re: [spi-devel-general] [PATCH 0/5] spi-imx: some updates
From: jassi brar <jassisinghbrar@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, Daniel Mack <daniel@caiaq.de>,
       =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       spi-devel-general@lists.sourceforge.net,
       linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 9, 2009 at 9:25 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> 2009/12/8 Andrew Morton <akpm@linux-foundation.org>:
>> On Tue, 8 Dec 2009 22:12:58 +0100
>> Uwe Kleine-K__nig <u.kleine-koenig@pengutronix.de> wrote:
>>
>>> this series depends on "spi: drain MXC SPI transfer buffer when probing
>>> device" which is currently in -mm and also included in my spi-imx branch
>>> (see below).  IMHO at least my first patch should go into .33 as it
>>> fixes an oops.
>>
>> I queued all five for 2.6.33.
>
> I had also picked up "drain MXC SPI transfer..." into my next-spi tree
> earlier today.  After a few days I'll send Linus a pull request.  I
> just need to make sure that Ben's tree gets pulled first because I've
> got other stuff in there depending on it.
>
>> Once I've merged up the current -mm patch queue:
> [... list of patches snipped ...]
>> I shall stop sending SPI patches to Linus.  I'll send any which I
>> accumulate to Grant instead.
>
> I'm new to the job, so I'm being cautions about which things I'm pick
> up.  However, I'll happily merge anything that Andrew says is okay.
> Andrew, when in the merge window do you typically send out patch
> queues?
>

Grant, may I know of your tree, if it's public?
thanks
