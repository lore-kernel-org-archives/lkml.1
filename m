Return-Path: <linux-kernel-owner+w=401wt.eu-S1030218AbXBZNJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030218AbXBZNJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 08:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030217AbXBZNJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 08:09:19 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45842 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030218AbXBZNJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 08:09:05 -0500
Date: Mon, 26 Feb 2007 14:12:22 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: "Pavel Machek" <pavel@ucw.cz>, davids@webmaster.com,
       "v j" <vj.linux@gmail.com>, trent.waddington@gmail.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       "Neil Brown" <neilb@suse.de>
Subject: Re: GPL vs non-GPL device drivers
Message-ID: <20070226141222.79fe37e7@lxorguk.ukuu.org.uk>
In-Reply-To: <f2b55d220702260216j17003b19l44d8275d9e87950@mail.gmail.com>
References: <3d57814d0702191458l1021caeyaefd7775398c5f2a@mail.gmail.com>
	<MDEHLPKNGKAHNMBLJOLKIEFNBLAC.davids@webmaster.com>
	<f2b55d220702211408r7954d5dar2c59e1e679316811@mail.gmail.com>
	<20070225104211.GB2045@elf.ucw.cz>
	<f2b55d220702250354j29583e5ak1397d28ef7028783@mail.gmail.com>
	<20070225135208.6e2eab9c@lxorguk.ukuu.org.uk>
	<f2b55d220702250621h1877f8e8x19293cc8b95bf56@mail.gmail.com>
	<20070225191028.4f0ecdfb@lxorguk.ukuu.org.uk>
	<f2b55d220702260216j17003b19l44d8275d9e87950@mail.gmail.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Macrovision.

Just about every vendors hardware can do Macrovision. They just forget to
include the Macrovision control in published code, or hide it in a tiny
extra driver (Matrox) or in the BIOS switching firmware (SiS)

> Just so you know I'm not making this up:  I know where the "defeat
> Macrovision" bits are on certain devices, and if I told you, Jack

They've been published repeatedly, people have even released source code
with some of the macrovision functions included. One of the DVD hardware
vendors for example released complete Macrovision programming code for
their DVD hardware to the public.

The Nvidia driver code sets that have been investigated show no sign of
either secret macrovision code or delay loops, or stuff crippling the
chip. There is a reason for the last twopeople do speed limiting with
hardware traces because every kiddie on the planet can do software or
jumper based ones. 

Alan
