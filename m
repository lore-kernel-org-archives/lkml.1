Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408Ab0AWBU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab0AWBU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 20:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953Ab0AWBU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 20:20:57 -0500
Received: from kroah.org ([198.145.64.141]:48551 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927Ab0AWBU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 20:20:56 -0500
Date: Fri, 22 Jan 2010 17:20:02 -0800
From: Greg KH <greg@kroah.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, a.p.zijlstra@chello.nl,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>, mingo@elte.hu,
       Yinghai Lu <yinghai@kernel.org>, stable@kernel.org
Subject: Re: [stable] RFC: deprecate CONFIG_X86_CPU_DEBUG and schedule it
 for rapid removal
Message-ID: <20100123012002.GA8655@kroah.com>
References: <4B4E1633.8010700@pardus.org.tr>
 <201001162312.34189.rjw@sisk.pl>
 <4B52D6E2.8000904@pardus.org.tr>
 <201001171444.14551.rjw@sisk.pl>
 <4B53B8DD.9000809@zytor.com>
 <20100122165356.55cf88aa.akpm@linux-foundation.org>
 <4B5A4B44.3010002@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5A4B44.3010002@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 05:05:08PM -0800, H. Peter Anvin wrote:
> On 01/22/2010 04:53 PM, Andrew Morton wrote:
> > 
> > Would it not be better to fix that problem (perhaps just with the
> > revert) so that 2.6.33, 2.6.32.x and earlier can be fixed?  Then we can
> > nuke the feature in 2.6.34.
> > 
> > Alternatively, we can nuke the feature from 2.6.33 and 2.6.32.x and
> > earlier right now.  Where "nuke" might mean "make it difficult to
> > enable".
> > 
> > Whatever.  Bottom line is that it'd be nice to do something to fix up
> > 2.6.33 and earlier.
> > 
> 
> I would be all for nuking the feature immediately.  The easiest way to
> nuke the feature quickly is to make it a noninteractive Kconfig feature.
> 
> All in favor?

/me raises his hand.

A Kconfig change would be nice to have.

thanks,

greg k-h
