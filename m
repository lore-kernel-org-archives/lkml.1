Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbXEJHvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbXEJHvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 03:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756932AbXEJHvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 03:51:43 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4176 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269AbXEJHvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 03:51:43 -0400
Date: Thu, 10 May 2007 08:51:34 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] MMC updates
Message-ID: <20070510075134.GA27832@flint.arm.linux.org.uk>
Mail-Followup-To: Pierre Ossman <drzeus-list@drzeus.cx>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <46375B18.4080802@drzeus.cx> <20070509185636.GB26981@flint.arm.linux.org.uk> <46421BB5.7040504@drzeus.cx> <20070509221253.GC26981@flint.arm.linux.org.uk> <4642B122.5070609@drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4642B122.5070609@drzeus.cx>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 07:44:02AM +0200, Pierre Ossman wrote:
> Russell King wrote:
> > See the comments immediately above and below its use.
> >
> > Welcome to buggy hardware.
> 
> I've read through the erratum, and to me it seems like the bug affects
> all long replies, not just these codes. So I think the code should be
> fixed to look at the response flag, not the opcode.
> 
> Do you have hardware so that you can test such a change?

Nope.  Suggest checking the git logs and contacting those who authored
the change.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
