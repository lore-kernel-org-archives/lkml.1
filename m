Return-Path: <linux-kernel-owner+w=401wt.eu-S1760472AbYFMACT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760472AbYFMACT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 20:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbYFMACH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 20:02:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:49278 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbYFMACG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 20:02:06 -0400
Date: Thu, 12 Jun 2008 16:54:41 -0700
From: Greg KH <greg@kroah.com>
To: Will Newton <will.newton@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       kernel-janitors@vger.kernel.org, linux-next@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [ANNOUNCE] linux-staging tree created
Message-ID: <20080612235441.GC4792@kroah.com>
References: <20080610190540.GA25066@kroah.com> <87a5b0800806110345v77529fc8r591f2fb4c95b5bdf@mail.gmail.com> <20080611162639.GE22134@kroah.com> <87a5b0800806120437n23602ba5raae500f5bd3d179f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a5b0800806120437n23602ba5raae500f5bd3d179f@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 12:37:56PM +0100, Will Newton wrote:
> On Wed, Jun 11, 2008 at 5:26 PM, Greg KH <greg@kroah.com> wrote:
> > On Wed, Jun 11, 2008 at 11:45:55AM +0100, Will Newton wrote:
> >>
> >> Would the linux-staging tree be an appropriate place to merge a new
> >> architecture? Or would that be too large a change and should go via
> >> its own tree?
> >
> > That is probably too big to go into -staging and should deserve its own
> > tree based on the size of patches that have gone into creating a new
> > architecture in the past.
> 
> Our tree is about 26000 lines of diff, including a few drivers.

That's pretty sizable, I think it deserves its own tree.

> > Do you have an example of one that is currently not included in the main
> > kernel tree right now?
> 
> I have a tree that is currently about half way to public consumption,
> although I don't think there's any point pushing it until we have a
> publically available toolchain.

Yeah, that would help as well :)

thanks,

greg k-h
