Return-Path: <linux-kernel-owner+w=401wt.eu-S1753703AbZCQTUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbZCQTUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 15:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbZCQTUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 15:20:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37666 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZCQTUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 15:20:04 -0400
Date: Tue, 17 Mar 2009 19:19:46 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Cyril Hrubi? <metan@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       rpurdie@rpsys.net, lenz@cs.wisc.edu, Dirk@opfer-online.de,
       arminlitzel@web.de, pavel.urban@ct.cz, thommycheck@gmail.com,
       milan@ucw.cz
Subject: Re: 2.6.29-rc1 on zaurus (spitz)
Message-ID: <20090317191946.GA13630@flint.arm.linux.org.uk>
References: <20090128113809.GA29424@elf.ucw.cz> <dc2200690902121322l4e16cf84h25d2871ca80c37a3@mail.gmail.com> <20090222135651.GD1387@ucw.cz> <20090222142345.GA21948@flint.arm.linux.org.uk> <20090314162439.GC1496@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090314162439.GC1496@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 14, 2009 at 05:24:39PM +0100, Pavel Machek wrote:
> > > About hda timeouts... I remember seeing them under older kernels, too,
> > > under loads such as kernel compile... plus keypresses tend to get lost
> > > under high loads :-(.
> > 
> > Really, what we need is for someone to step up to take on sorting out
> > Zaurus.  Looking at this thread, it seems there's very few people here
> > willing.  Also, I think Richard Purdie has moved on from Zaurus stuff.
> > 
> > I know there are a small number of people on linux-arm-kernel who have
> > access to some Zaurus platforms, but I don't know what they are.  Really,
> > you should be posting to that list if you seriously want help, because
> > I doubt they're subscribed to LKML.
> 
> linux-arm-kernel seems subscriber-only :-(.

Yes.

> Anyway, new problem blocking testing is that somewhere between
> 2.6.29-rc3 and -rc7, pcmcia support stopped working => hda is no
> longer detected.

lalala, I'm not listening.

Really, if you want help, I've pointed you at the place where you can
get that.  I'm not able to give you any other help with your Zaurus
problems.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
