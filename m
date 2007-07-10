Return-Path: <linux-kernel-owner+w=401wt.eu-S1765033AbXGJJei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765033AbXGJJei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764769AbXGJJcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:32:47 -0400
Received: from smtp1-g19.free.fr ([212.27.42.27]:49478 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764763AbXGJJcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:32:46 -0400
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: mikie <mikie.pl@gmail.com>
Subject: Re: understanding firmware loader for speedtouch (kernel 2.6.21.5)
Date: Tue, 10 Jul 2007 11:32:50 +0200
User-Agent: KMail/1.9.7
Cc: "Indan Zupancic" <indan@nul.nu>, "Kay Sievers" <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org
References: <ca35ce500707060554v71ebdca3k8ef18e4c0a44c9cb@mail.gmail.com> <200707101057.57538.duncan.sands@math.u-psud.fr> <ca35ce500707100213n10b08cc1y8b09957cd3a655d4@mail.gmail.com>
In-Reply-To: <ca35ce500707100213n10b08cc1y8b09957cd3a655d4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707101132.50815.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 July 2007 11:13:09 mikie wrote:
> 2007/7/10, Duncan Sands <duncan.sands@math.u-psud.fr>:
> > > I also tried a couple of other firmwares available on the net, and
> > > also the one from Windows XP install (which works and achieves speeds
> > > of up to 720kbyte/sec downlink). Some of the firmwares did not work
> > > either, and some worked the same way - it means not more than 3mbit/s
> > > (around 400kbyte/s) could be achieved.
> >
> > I'm pretty sure you won't get anything faster out of a revision 2 modem.
> 
> Too bad to hear that :/
> Especially that windows does this with the same modem without a hitch.

Really?  In that case I take it back, the hardware can clearly do it :)  Presumably
you are using the firmware that came with windows?  Which kernel version?  Also, what
synchronization speed is reported?

> Anyway thanks for all your help.

No problem.

Duncan.
