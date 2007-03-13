Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbXCMLYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbXCMLYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 07:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbXCMLYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 07:24:15 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:53848 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbXCMLYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 07:24:13 -0400
Date: Tue, 13 Mar 2007 11:24:11 +0000
From: Ben Dooks <ben@fluff.org.uk>
To: Maxin John <maxin.john@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Need help on mach-ep93xx
Message-ID: <20070313112411.GA24508@fluff.org.uk>
References: <9debc4410703122224n5def90e7g4767b95b176941c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9debc4410703122224n5def90e7g4767b95b176941c0@mail.gmail.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 10:54:08AM +0530, Maxin John wrote:
> Hi,
> 
> I have one question mach-ep93xx.
> 
> In  EP93xx  IRQ handling part in core.c,  the 2.6.19.2 kernel and
> newer  kernels are configuring the 16 interrupts of the ports A & B
> together. The code is not using the  interrupt capability  of the port
> F which can provide 3 interrupts.
> 
> Why the port F is not configured for interrupts ?
> 
> Thanks in advance,

subscribe to the linux-arm-kernel list and ask
the question there, you'll find more ARM people there.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
