Return-Path: <linux-kernel-owner+w=401wt.eu-S1760261AbXFVWVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261AbXFVWVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754946AbXFVWVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:21:14 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1558 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555AbXFVWVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:21:13 -0400
Date: Sat, 23 Jun 2007 00:21:28 +0200 (CEST)
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
In-Reply-To: <a781481a0706221501s4887f88bh3b8cc549deb6886e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706230017430.1817@scrub.home>
References: <200706211117.55908.toralf.foerster@gmx.de> 
 <200706211231.53898.luca.risolia@studio.unibo.it>  <200706211326.45031.toralf.foerster@gmx.de>
  <200706211350.14526.oneukum@suse.de>  <1182518566.14289.20.camel@gaivota>
  <Pine.LNX.4.58.0706221259500.4914@shell4.speakeasy.net> 
 <a781481a0706221420u6935e75er1ee5601e013b40d2@mail.gmail.com> 
 <Pine.LNX.4.64.0706222336210.1817@scrub.home>
 <a781481a0706221501s4887f88bh3b8cc549deb6886e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 23 Jun 2007, Satyam Sharma wrote:

> > menuconfig is really a type of config symbol, rather than a type of menu.
> 
> Well, I'd have to disagree here. A config symbol has code associated
> with it (at least _all_ config symbols in the kernel originally did, till
> when these "menuconfig" things got introduced, which is precisely
> what made them "special").

Only because it's currently used mostly like this, it doesn't add any 
"special" meaning.

bye, Roman
