Return-Path: <linux-kernel-owner+w=401wt.eu-S1031571AbXD1RZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031571AbXD1RZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031575AbXD1RZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:25:42 -0400
Received: from mx33.mail.ru ([194.67.23.194]:22094 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031571AbXD1RZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:25:41 -0400
Date: Sat, 28 Apr 2007 21:23:52 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Greg KH <gregkh@suse.de>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ANNOUNCE] battery2 git repository
Message-ID: <20070428172352.GA8124@zarina>
Reply-To: cbou@mail.ru
References: <20070426232902.GA10423@zarina> <20070427000928.GA5303@suse.de> <1177653814.2755.466.camel@pmac.infradead.org> <20070427235553.GC24476@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070427235553.GC24476@suse.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 04:55:53PM -0700, Greg KH wrote:
> On Fri, Apr 27, 2007 at 07:03:34AM +0100, David Woodhouse wrote:
> > On Thu, 2007-04-26 at 17:09 -0700, Greg KH wrote:
> > > So, I'm still not quite understanding this, is David giving up on his
> > > code now that you have pulled his changes into your tree?  Or is there
> > > some reason there are still two competing versions here?
> > 
> > Anton hasn't pulled my changes -- it's a separate implementation,
> > although very similar. In return for the account on git.infradead.org he
> > said he was going to port the two drivers I already had (PMU and OLPC)
> > to his framework.
> 
> Hopefully he took the driver model fixes you did.

Like class_device -> device transition? Yup.

> Anton, care to send a
> new set of patches, so we can review them?

Sure! But please let me do it tomorrow, to send it I need merge
intermediate commits, and I'm in OLPC battery writing mood. ;-)

If cumulative "git diff linus" is acceptable, I can send it now.

> thanks,
> 
> greg k-h

Good day,

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
