Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab0BXNuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 08:50:05 -0500
Received: from kroah.org ([198.145.64.141]:60072 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757077Ab0BXNuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 08:50:03 -0500
Date: Wed, 24 Feb 2010 05:24:14 -0800
From: Greg KH <greg@kroah.com>
To: Am??rico Wang <xiyou.wangcong@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] windfarm: init sysfs attributes
Message-ID: <20100224132414.GB21421@kroah.com>
References: <1266674493.18465.9.camel@jlt3.sipsolutions.net> <20100220150327.GG3000@hack> <1266678496.32309.1.camel@jlt3.sipsolutions.net> <20100220152010.GI3000@hack> <1266679687.17363.1.camel@jlt3.sipsolutions.net> <20100220154049.GM3000@hack> <1266680582.17363.7.camel@jlt3.sipsolutions.net> <1266979753.23523.1670.camel@pasglop> <1266996757.3903.0.camel@jlt3.sipsolutions.net> <2375c9f91002232334p219f4ebem6006172153e7a3f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2375c9f91002232334p219f4ebem6006172153e7a3f1@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 03:34:52PM +0800, Am??rico Wang wrote:
> On Wed, Feb 24, 2010 at 3:32 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2010-02-24 at 13:49 +1100, Benjamin Herrenschmidt wrote:
> >> On Sat, 2010-02-20 at 16:43 +0100, Johannes Berg wrote:
> >> > This is required for lockdep.
> >>
> >> Please CC linuxppc-dev@ozlabs.org or it doesn't get caught by
> >> patchwork.
> >
> > Eh, sure, but I think it needs to be part of Eric's series?
> >
> 
> Yeah, that's why we are Cc'ing Greg, since he took Eric's patches already.
> 
> Greg?

I didn't take all of them yet, that will happen later today, and I'll
also queue this up, as it is then required.

thanks,

greg k-h
