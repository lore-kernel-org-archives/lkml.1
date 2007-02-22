Return-Path: <linux-kernel-owner+w=401wt.eu-S1751912AbXBVVZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbXBVVZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 16:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbXBVVZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 16:25:27 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:53229 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbXBVVZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 16:25:25 -0500
Date: Thu, 22 Feb 2007 22:25:24 +0100
From: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Arjan van de Ven <arjan@infradead.org>, tglx@linutronix.de,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: NO_HZ: timer interrupt stuck [Re: Linux 2.6.21-rc1]
Message-ID: <20070222212524.GA16830@rhlx01.hs-esslingen.de>
References: <Pine.LNX.4.61.0702221334460.28624@yvahk01.tjqt.qr> <1172150712.3531.265.camel@laptopd505.fenrus.org> <45DDA43A.4030509@drzeus.cx> <1172154034.3531.270.camel@laptopd505.fenrus.org> <45DDADEB.3030309@drzeus.cx> <45DDB31C.8070306@drzeus.cx> <1172160024.25076.188.camel@localhost.localdomain> <45DDC488.1080008@drzeus.cx> <1172162526.3531.275.camel@laptopd505.fenrus.org> <45DE0607.2090601@drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DE0607.2090601@drzeus.cx>
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Feb 22, 2007 at 10:07:19PM +0100, Pierre Ossman wrote:
> Arjan van de Ven wrote:
> > no; c3 saves a TON more power. 
> >
> > you can try enabling HPET in your BIOS...
> >
> >   
> 
> Hah, I wish! This is a laptop, so the BIOS is as brain dead and broken
> as is humanly possible.
> 
> Can I determine if I have the required hardware? So I can tell if I'm
> permanently screwed, or just temporarily.

http://lkml.org/lkml/2006/11/14/153

and related posts in this older thread
("CONFIG_NO_HZ: missed ticks, stall (keyb IRQ required) [2.6.18-rc4-mm1]")
should help.

Andreas Mohr
