Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbXFWA0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbXFWA0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 20:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbXFWA0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 20:26:33 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3274 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603AbXFWA0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 20:26:31 -0400
Date: Sat, 23 Jun 2007 02:26:43 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: Trent Piepho <xyzzy@speakeasy.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>, toralf.foerster@gmx.de,
       Oliver Neukum <oneukum@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Luca Risolia <luca.risolia@studio.unibo.it>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re:
 [linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in zc0301_core.c
In-Reply-To: <a781481a0706221649j19f9ce2apcf295ddf9530da1e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706230216140.1817@scrub.home>
References: <200706211117.55908.toralf.foerster@gmx.de> 
 <Pine.LNX.4.58.0706221259500.4914@shell4.speakeasy.net> 
 <a781481a0706221420u6935e75er1ee5601e013b40d2@mail.gmail.com> 
 <Pine.LNX.4.64.0706222336210.1817@scrub.home> 
 <a781481a0706221501s4887f88bh3b8cc549deb6886e@mail.gmail.com> 
 <Pine.LNX.4.64.0706230017430.1817@scrub.home> 
 <a781481a0706221533j34c341c5gf7ff92997e2463a6@mail.gmail.com> 
 <Pine.LNX.4.64.0706230049480.1817@scrub.home> 
 <a781481a0706221626q17f533ccnac09b2cc7c89126d@mail.gmail.com> 
 <Pine.LNX.4.64.0706230137090.1817@scrub.home>
 <a781481a0706221649j19f9ce2apcf295ddf9530da1e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 23 Jun 2007, Satyam Sharma wrote:

> But why? Let it do just one thing, and do it well. Is their
> any requirement anywhere that requires us to give a dual
> meaning to these menuconfig objects -- i.e. to also control
> the inclusion / exclusion of code from the kernel as well as
> also for the presentation + user interface purpose that it
> currently serves?

This getting ridiculous. :-(
You're the one who is attaching a new meaning to it.
Any config symbol has multiple meanings depending on the context, the menu 
property only changes _one_ of them, you want to drastically redefine it 
and that's not going to happen.

bye, Roman
