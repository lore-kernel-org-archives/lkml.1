Return-Path: <linux-kernel-owner+w=401wt.eu-S1762606AbXG2Mbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762606AbXG2Mbu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 08:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760615AbXG2Mbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 08:31:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49367 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759573AbXG2Mbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 08:31:41 -0400
Date: Sun, 29 Jul 2007 13:31:20 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>, Adrian Bunk <bunk@stusta.de>,
       spyro@f2s.com, john@dnsworld.co.uk, linux-kernel@vger.kernel.org
Subject: Re: RFC: Remove the arm26 port
Message-ID: <20070729123119.GA25431@flint.arm.linux.org.uk>
References: <20070707201208.GJ3492@stusta.de> <20070729115040.GD30976@stusta.de> <20070729121012.GA1375@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070729121012.GA1375@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 01:10:12PM +0100, Christoph Hellwig wrote:
> On Sun, Jul 29, 2007 at 01:50:40PM +0200, Adrian Bunk wrote:
> > Considering the state of the arm26 port, I do hereby suggest to remove 
> > it from the Linx kernel since it's far from a usable state and doesn't 
> > seem to come back into a usable state.
> > 
> > If anyone wants to work on getting this port back into a usable state in 
> > the forseeable future he should speak up now.
> 
> Yes, please.  This bitrotting code has been in the way for quite bit of
> cross-architecture work I've been doing.
> 
> Btw, there's probably no point to Cc rmk as he's not involved with that
> stinkin' pile.

Definitely - I'd like to see it gone so hopefully I'll stop being copied
on every single janitorial change to it.

(And yes, I've re-enabled mail-followup-to since otherwise I can't
group-reply in mutt to everyone - without it I just get hch in the To:
header and an empty CC: with 'g'.  Tough shit to those anti-mail-followup-to
people.  It's the only thing that actually works.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
