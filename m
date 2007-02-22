Return-Path: <linux-kernel-owner+w=401wt.eu-S1751753AbXBVScf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbXBVScf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 13:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbXBVScf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 13:32:35 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41193 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751753AbXBVScf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 13:32:35 -0500
Date: Thu, 22 Feb 2007 19:32:31 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Patrick Ale <patrick.ale@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [SKY2] Does anyone have this driver working?
Message-ID: <20070222183231.GB8603@stusta.de>
References: <8d158e1f0702211313m4bf85628t419627f7bf096281@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d158e1f0702211313m4bf85628t419627f7bf096281@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 10:13:01PM +0100, Patrick Ale wrote:

> Hi,

Hi Patrick,

> And now, for something completely different, no libata ;-)
> 
> I was wondering if any of you ever got the sky2 driver working

there are many people who are successfully using this card.

> (gigabit network card found in most Siemens E laptops).
> 
> Which kernel I am trying, 2.6.17-gentoo (the kernel on the install
> CD), 2.6.20, the latest gits, nothing works. It either tells me "Link
> not ready" when bringing the interface up or it just gives massive
> time outs.
> 
> Then, after literaly 6 reboots, it might get a DHCPACK, work, till the
> next reboot, then same story all over again.
> 
> Any clue towards module settings or patches are welcome,

The maintainer for this driver is:

SKGE, SKY2 10/100/1000 GIGABIT ETHERNET DRIVERS
P:      Stephen Hemminger
M:      shemminger@linux-foundation.org
L:      netdev@vger.kernel.org
S:      Maintained

> At the moment I am compiling Jeff's netdev upstream-linus.
> 
> Patrick

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

