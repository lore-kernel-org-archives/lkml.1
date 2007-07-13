Return-Path: <linux-kernel-owner+w=401wt.eu-S934960AbXGMGWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934960AbXGMGWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 02:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756814AbXGMGWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 02:22:01 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:6219 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbXGMGWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 02:22:00 -0400
X-IronPort-AV: i="4.16,535,1175486400"; 
   d="scan'208"; a="34796913:sNHT31957842"
Subject: Re: Linux 2.6.22.1
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Greg KH <greg@kroah.com>
Cc: Bryan Wu <bryan.wu@analog.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org,
       Nish Aravamudan <nish.aravamudan@gmail.com>
In-Reply-To: <20070713061617.GA24317@kroah.com>
References: <29495f1d0707121135u2a07cf04nb8bfe555c5c63679@mail.gmail.com>
	 <1184307380.8943.7.camel@roc-desktop>  <20070713061617.GA24317@kroah.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Fri, 13 Jul 2007 14:28:20 +0800
Message-Id: <1184308100.8943.12.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
X-OriginalArrivalTime: 13 Jul 2007 06:21:59.0127 (UTC) FILETIME=[1E46FE70:01C7C516]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 23:16 -0700, Greg KH wrote:
> On Fri, Jul 13, 2007 at 02:16:20PM +0800, Bryan Wu wrote:
> > On Fri, 2007-07-13 at 02:35 +0800, Nish Aravamudan wrote:
> > > On 7/10/07, Greg KH <greg@kroah.com> wrote: 
> > > > We (the -stable team) are announcing the release of the 2.6.22.1
> > > kernel. 
> > > > It contains a security fix for SCTP that somehow forgot to be added
> > > to 
> > > > the 2.6.22 kernel (was already released in the 2.6.21.y releases). 
> > > > Thanks to Patrick McHardy for noticing the mistake. 
> > > > 
> > > > I'll also be replying to this message with a copy of the patch
> > > between 
> > > > 2.6.22 and 2.6.22.1 
> > > > 
> > > > The updated 2.6.22.y git tree can be found at: 
> > > >
> > > git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
> > > 
> > > Can you please also update
> > > 
> > >  git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6-stable.git
> > > 
> > > ? Maybe make that update part of whatever process you use to push out 
> > > the 2.6.Y trees, as I've had to ask for this more than once now?
> > > 
> > 
> > Could you please open http:// git-pull? I was blocked by company's
> > firewall except http method -:((.
> 
> That is up to the kernel.org admins, but last time I checked, I think it
> was enabled already.  Can you pull anything else from kernel.org with
> http but not this tree?
> 

I can git-pull from Linus tree through http in my company, this one
can't. If it is not easy to open it by you guys, I have to git-pull at
home, -:))

Thanks anyway

- Bryan
