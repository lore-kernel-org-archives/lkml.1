Return-Path: <linux-kernel-owner+w=401wt.eu-S1762450AbYD0Rud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762450AbYD0Rud (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 13:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757754AbYD0Ru0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 13:50:26 -0400
Received: from 1wt.eu ([62.212.114.60]:3457 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756585AbYD0RuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 13:50:25 -0400
Date: Sun, 27 Apr 2008 19:49:47 +0200
From: Willy Tarreau <w@1wt.eu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>,
       jbarnold@MIT.EDU, francois.cami@free.fr,
       Andi Kleen <andi@firstfloor.org>, mail@earthworm.de
Subject: Re: A system for rebootless kernel security updates
Message-ID: <20080427174947.GI8474@1wt.eu>
References: <481098A4.50107@wpkg.org> <20080427101659.GD3891@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427101659.GD3891@ucw.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 12:17:00PM +0200, Pavel Machek wrote:
> On Thu 2008-04-24 16:26:44, Tomasz Chmielewski wrote:
> > Jeff Arnold wrote:
> > 
> > >I've put together an automatic system for applying 
> > >kernel security patches to the Linux kernel without 
> > >rebooting it, and I wanted to share this system with 
> > >the community in case others find it useful or 
> > >interesting.
> > 
> > Hmm, the idea seem to be patented by Microsoft, i.e. 
> > this patent from December 2002:
> > 
> > http://www.google.com/patents?id=cVyWAAAAEBAJ&dq=hotpatching
> > 
> > (and other patents by Microsoft if you search for 
> > "hotpatching").
> 
> ...so US will not be able to fix security holes without reboot, good.
> Perhaps they fix their stupid laws after next worm outbreak...

Sounds like a bullshit patent. I remember having loaded a lot of NLM
patches under netware 4.0 in 96-97 without ever rebooting. I think
that the patches only redefined the faulty symbol(s) they wanted to
patch. That was pretty convenient because when in doubt, you could
simply unload the modules and get back to previous situation.

> 							Pavel

Willy

