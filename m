Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbXFWMQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbXFWMQE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 08:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbXFWMPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 08:15:54 -0400
Received: from barikada.upol.cz ([158.194.242.200]:53286 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbXFWMPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 08:15:53 -0400
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Trent Piepho <xyzzy@speakeasy.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Linux and Kernel Video <video4linux-list@redhat.com>,
       linux-usb-devel@lists.sourceforge.net, toralf.foerster@gmx.de,
       Oliver Neukum <oneukum@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Luca Risolia <luca.risolia@studio.unibo.it>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re: linux-2.6.22-rc5-gf1518a0 build #300 failed in zc0301_core.c
In-Reply-To: <Pine.LNX.4.64.0706230010330.26568@fbirervta.pbzchgretzou.qr>
References: <200706211117.55908.toralf.foerster@gmx.de> <200706211231.53898.luca.risolia@studio.unibo.it> <200706211326.45031.toralf.foerster@gmx.de> <200706211350.14526.oneukum@suse.de> <1182518566.14289.20.camel@gaivota> <Pine.LNX.4.58.0706221259500.4914@shell4.speakeasy.net> <a781481a0706221420u6935e75er1ee5601e013b40d2@mail.gmail.com> <Pine.LNX.4.64.0706230010330.26568@fbirervta.pbzchgretzou.qr>
Date: Sat, 23 Jun 2007 14:28:34 +0200
Message-Id: <E1I24jC-0005kM-9W@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Newsgroups: linux.kernel,comp.video.video4linux,linux.usb.devel

As you might know, there's no organized central traking system, thus
this huge lists of MLs...

> But, as always, you need someone to code it, etc.

... and no relevant one, where somebody can actually see the problem
and/or to code it. Please, care to add <kbuild-devel@lists.sourceforge.net>
next time.

> On Jun 23 2007 02:50, Satyam Sharma wrote:
>>
[]
>> menuconfig FOO
>> if FOO
>> ...
>> endif # FOO
>>
>> idiom is converted to an:
>>
>> configmenu FOO
>> ...
>> endconfigmenu # FOO
>>
>> kind of idiom ...

Bah, i can't believe. Guys, are you serious about not converting
everything in to XML ?:)
____
