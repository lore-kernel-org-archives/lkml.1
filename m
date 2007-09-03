Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592AbXICMGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbXICMGn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 08:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbXICMGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 08:06:33 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:44236 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbXICMGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 08:06:33 -0400
Message-ID: <3db1ec7f0709030506j5fe6dbc3w6c7ae8daa94c3323@mail.gmail.com>
Date: Mon, 3 Sep 2007 15:06:30 +0300
From: "Ivan N. Zlatev" <contact@i-nz.net>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [PATCH] [ALSA] Added new pin config for first gen macbook.
Cc: "Abhijit Bhopatkar" <bain@devslashzero.com>,
       "Jaroslav Kysela" <perex@suse.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <3db1ec7f0709030407y2cb9fc8ew52160ca28b2592d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2ff216280709030325r626d98b3h2c5a48e90470610b@mail.gmail.com>
	 <s5hr6lgdoiv.wl%tiwai@suse.de>
	 <3db1ec7f0709030407y2cb9fc8ew52160ca28b2592d2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/3/07, Ivan N. Zlatev <contact@i-nz.net> wrote:
> On 9/3/07, Takashi Iwai <tiwai@suse.de> wrote:
> > At Mon, 3 Sep 2007 15:55:18 +0530,
> > Abhijit Bhopatkar wrote:
> > >
> > > commit 5d5d3bc3eddf2ad97b2cb090b92580e7fed6cee1 changed all
> > > pin configs for intel macs, but it breaks sound on
> > > Macbook first generation.
> >
>
> For the record I have just verified that according to Apple the
> pinconfigs for your codec match the ones in alsa and are as follows. I
> believe those were extracted from Boot Camp 1.2. I will check with
> version 1.4 in few hours.

Nope, no change since 1.2.

>
> [0A]
> CfgDflt = 0x0321E21F
> Action = 01,0A,81,0C,81,0D,81,10,85,51,05,21
> [0B]
> CfgDflt = 0x03A1E02E
> FF,04
> [0C]
> CfgDflt = 0x9017E110
> [0D]
> CfgDflt = 0x9017E11F
> [0E]
> CfgDflt = 0x400000FE
> Action = hex: 01,10,81,0A,81,0C,81,0D
> [0F]
> CfgDflt = 0x0381E020
> Action = 09,0F
> [10]
> CfgDflt = 0x1345E230
> [11]
> CfgDflt = 0x13C5E240
> [15]
> CfgDflt = 0x400000FC
> [1B]
> CfgDflt = 0x400000FB
> --
> Ivan N. Zlatev
>
> Web: http://www.i-nZ.net
> "It's all some kind of whacked out conspiracy."
>


-- 
Ivan N. Zlatev

Web: http://www.i-nZ.net
"It's all some kind of whacked out conspiracy."
